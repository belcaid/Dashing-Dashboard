require 'insightly'
require 'json'

module Insightly
  autoload :Client, 'insightly/client'
  autoload :DSL, 'insightly/dsl'
  autoload :Resources, 'insightly/resources'
  autoload :Errors, 'insightly/errors'
  autoload :Utils, 'insightly/utils'

  class << self
    # @return [String]
    attr_accessor :api_key
    attr_accessor :logger
  end

  module_function
end

# Api Insightly se trouvant dans le profil de l'utilisateur
Insightly.api_key = '<your API key>'



# Lancement du rafraichissement
SCHEDULER.every '1m', :first_in => 0 do

contact = Insightly.client.get_contact(id: 1)
  
 
  # Update the dashboard
  send_event('listedetaches',   { items: contact })
end
