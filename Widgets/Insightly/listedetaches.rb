require 'insightly'
require 'json'
require "net/http"

# Api Insightly se trouvant dans le profil de l'utilisateur
Insightly.api_key = '<your API key>'





# Lancement du rafraichissement
SCHEDULER.every '1m', :first_in => 0 do

contact = Insightly.client.get_contact(id: 1)
  
 
  # Update the dashboard
  send_event('listedetaches',   { items: contact })
end
