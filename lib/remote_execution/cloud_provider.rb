require 'fog'
require 'net/ssh'

class CloudProvider
  attr_accessor :provider_name, :provider, :virtual_machines, :instances

  def initialize(name, *args)
    @provider_name = name
    @provider = Fog::Compute.new(*args)
    @virtual_machines = Hash.new
    @instances = Array.new
  end

  def create_instance(instance_type, parameters)
    puts 'creating machine: ' + instance_type + '\n'
    parameters.store(:flavor_id, instance_type.split('=>').first)
    name = ("#{@provider_name}:" + instance_type).split('=>')
    machine = @provider.servers.bootstrap(parameters)
    @instances.push(machine)
    machine_id = @provider.servers.get(machine.id)
    vm = VirtualMachine.new(machine_id.public_ip_address, parameters[:username], :keys => parameters[:private_key_path])
    @virtual_machines.store(name.last, vm)
  end

  def create_instances(instances_types, *parameters)
    threads = []
    instances_types.each do |instance_type|
      threads.push(Thread.fork do
        create_instance(instance_type, parameters[0])
      end)
    end
    threads.each do |thread|
      thread.join
    end
    puts @virtual_machines
  end

  def destroy
    @instances.each { |instance| instance.destroy }
  end

end