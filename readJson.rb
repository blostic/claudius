require 'json'

def load_user_lib( filename )
  File.open( filename, "r" ) do |f|
    JSON.load( f )
  end
end

config = load_user_lib("./userConfig.json")
puts config["provider"]