require 'fog'
require 'net/ssh'

class CloudProvider
  attr_accessor :provider_name, :provider, :virtual_machines, :counter

  def initialize(name, *args)
    @provider_name = name
    @provider = Fog::Compute.new(*args)
    @virtual_machines = Hash.new
  end

  def create_instances(instances_types, *parameters)
    puts 'in creating instance block'
    parameters = parameters[0]
    instances_types.each do |instance_type|
      puts 'creating machine: ' + instance_type
      parameters.store(:flavor_id, instance_type.split('=>').first)
      name = ("#{@provider_name}:" + instance_type).split('=>')
      machine = @provider.servers.bootstrap(parameters)
      machine_id = @provider.servers.get(machine.id)
      vm = VirtualMachine.new(machine_id.public_ip_address, parameters[:username], :keys => parameters[:private_key_path])
      @virtual_machines.store(name.last, vm)
    end
  end

  def destroy
    @virtual_machines.each { |instance| instance.destroy }
  end

end