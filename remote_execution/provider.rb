require './remote_execution/virtual_machine.rb'
require './remote_execution/cloud_provider.rb'
require 'json'

$manual_instances = Hash.new
$cloud_providers = Hash.new

def provider (&block)
  yield
end

def manual(name, host, username, *args)
  $manual_instances.store(name, VirtualMachine.new(name, host, username, *args))
end

def cloud(name, *args)
  cloud_provider = CloudProvider.new(name, *args)
  $cloud_providers.store(name, cloud_provider)
  cloud_provider
end

def load_user_lib( filename )
  File.open( filename, 'r' ) { |file| JSON.load file }
end

def test
  # $manual_instances['kali'].invoke [['sleep 1'], ['sleep 1', 'sleep 1', 'sleep 1', 'sleep 1', 'sleep 1'], ['sleep 1', 'sleep 1']]
  # $manual_instances['kali'].invoke [['cd; mkdir ./Desktop/test_dir']]
  $cloud_providers['aws'].virtual_machines.each { |machine| machine.invoke [['cd; mkdir ./Desktop/test_dir'],['ls -al']] }
end