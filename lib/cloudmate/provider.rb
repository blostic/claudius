require 'cloudmate/virtual_machine'
require 'cloudmate/cloud_provider'

module Cloudmate

  $manual_instances = Hash.new
  $cloud_providers = Hash.new

  def self.define_providers (&block)
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
    $manual_instances['kali'].invoke [['sleep 1'], ['sleep 1', 'sleep 1', 'sleep 4', 'sleep 1', 'sleep 1'], ['sleep 1', 'sleep 1']]
    $manual_instances['kali'].invoke [['cd; mkdir ./Desktop/test_dir']]
    #$cloud_providers['aws'].virtual_machines.each { |machine| machine.invoke [['cd; mkdir ./Desktop/test_dir'],['ls -al','ps', 'who']] }
  end

end