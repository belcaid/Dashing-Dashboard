require 'insightly'

module insightly
# Api Insightly se trouvant dans le profil de l'utilisateur
Insightly.api_key = '<your API key>'
contact = Insightly.client.get_contact(id: 1)
end


# Lancement du rafraichissement
SCHEDULER.every '1m', :first_in => 0 do

  # Update the dashboard
  send_event('test',   { items: contact })
end
