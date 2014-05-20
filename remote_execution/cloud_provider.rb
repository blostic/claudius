require 'fog'

class CloudProvider
  attr_accessor :name, :provider, :instances, :virtual_machines

  def initialize(name, *args)
    @name = name
    @provider = Fog::Compute.new(*args)
    @instances = Array.new
    @virtual_machines = Array.new
  end


  def create_instances(instances_types, username, pem_file, *parameters)
    parameters[0].store(:username, username)
    instances_types.each do |instance_type|
      parameters[0].store(:flavor_id, instance_type)
      machine = @provider.servers.create parameters[0]
      machine.wait_for { print '.'; sshable? }
      @instances.push machine
      machine_id = @provider.servers.get(machine.id)
      @virtual_machines.push VirtualMachine.new(@name, machine_id.public_ip_address, 'ubuntu', {:keys => pem_file})
    end
  end

  def destroy
    @instances.each { |instance| instance.destroy }
  end

end
