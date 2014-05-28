require 'virtual_machine.rb'
require 'cloud_provider.rb'
require 'json'

$virtual_machines = Hash.new

class MachineManager
  attr_accessor :cloud_providers

  def initialize(&block)
    @virtual_machines = Hash.new
    @cloud_providers = Array.new
    instance_eval(&block) if block
    @cloud_providers.each do |provider|
      @virtual_machines = @virtual_machines.merge(provider.virtual_machines)
    end
    $virtual_machines = @virtual_machines
    puts $virtual_machines
  end

  def manual(name, host, username, *args)
    vm = VirtualMachine.new(host, username, *args)
    # vm.wait_for_sshable
    @virtual_machines.store(name, vm)

  end

  def cloud(name, *args)
    cloud_provider = CloudProvider.new(name, *args)
    @cloud_providers.push(cloud_provider)
    cloud_provider
  end

end

def load_user_lib( filename )
  File.open( filename, 'r' ) { |file_name|
    JSON.load(file_name)
  }
end

def define_providers (&block)
  MachineManager.new &block
end
