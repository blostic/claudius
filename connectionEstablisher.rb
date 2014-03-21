require 'fog'
require 'json'

def load_user_lib( filename )
  File.open( filename, "r" ) do |f|
    JSON.load( f )
  end
end

config = load_user_lib("./userConfig.json")

fog = Fog::Compute.new(
  :provider => config["provider"],
  :region=>config["region"],
  :aws_access_key_id => config["aws_access_key_id"],
  :aws_secret_access_key => config["aws_secret_access_key"]
)

server = fog.servers.create(
  :image_id=>'ami-311f2b45',
  :flavor_id=>'t1.micro',
  :key_name => config["key_name"],
  :groups => config["groups"]
)

server.wait_for { print "."; ready? }

server_id = fog.servers.get(server.id)
puts server_id.dns_name

sleep 5400

server.destroy
