require 'google/api_client'
require 'date'
 
# Update these to match your own apps credentials
service_account_email = '[YOUR SERVICE ACCOUNT EMAIL]' # Email of service account
key_file = 'path/to/your/keyfile.p12' # File containing your private key
key_secret = 'notasecret' # Password to unlock private key
profileID = '[YOUR PROFILE ID]' # Analytics profile ID.
 
# Get the Google API client
client = Google::APIClient.new(:application_name => '[YOUR APPLICATION NAME]', 
  :application_version => '0.01')
 
# Load your credentials for the service account
key = Google::APIClient::KeyUtils.load_from_pkcs12(key_file, key_secret)
client.authorization = Signet::OAuth2::Client.new(
  :token_credential_uri => 'https://accounts.google.com/o/oauth2/token',
  :audience => 'https://accounts.google.com/o/oauth2/token',
  :scope => 'https://www.googleapis.com/auth/analytics.readonly',
  :issuer => service_account_email,
  :signing_key => key)
 
# Start the scheduler
SCHEDULER.every '30m', :first_in => 0 do
 
  # Request a token for our service account
  client.authorization.fetch_access_token!
 
  # Get the analytics API
  analytics = client.discovered_api('analytics','v3')
 
  # Date de départ et date de fin
  startDate = DateTime.now.strftime("%Y-01-%d") # Premier mois de l'année courrante
  endDate = DateTime.now.strftime("%Y-%m-%d")  # Maintenant
 
 # Déclaration des array
  mois = Array.new
  visites = Array.new
  results = []
  
  # Éxecution de la requête
    visitesparmois_Linegraph = client.execute(:api_method => analytics.data.ga.get, :parameters => { 
    'ids' => "ga:" + profileID, 
    'start-date' => startDate,
    'end-date' => endDate,
    'dimensions'=> "ga:month",
    'metrics'=> "ga:sessions",
  })
 
 # Récupération des urls et du nombre de vues séparées
 mois = visitesparmois_Linegraph.data.rows.transpose[0]
 visites = visitesparmois_Linegraph.data.rows.transpose[1]
 
 # Affectation des données
  compteur = 0
  mois.each do |row|
  results << { x: mois[compteur].to_i, y: visites[compteur].to_i }
  compteur += 1
end 
 
 
  # Mise à jour du tableau de bord
  send_event('visitesparmois_linegraph',   { points: results, graphtype: 'area' })
end
