require 'fog'
require 'net/ssh'

class CloudProvider
  attr_accessor :provider_name, :provider, :virtual_machines, :counter

  def initialize(name, *args)
    @provider_name = name
    @provider = Fog::Compute.new(*args)
    @virtual_machines = Hash.new
  end
  #
  # def wait_for_machines() do
  #   ssh.open_channel do |channel|
  #     channel.exec("ls -al") do |ch, success|
  #       abort "could not execute command" unless success
  #
  #       channel.on_data do |ch, data|
  #         #puts "got stdout: #{data}"
  #         #channel.send_data "something for stdin\n"
  #         counter+=1
  #       end
  #
  #       channel.on_extended_data do |ch, type, data|
  #         puts "got stderr: #{data}"
  #       end
  #
  #       channel.on_close do |ch|
  #         puts "channel is closing!"
  #       end
  #     end
  #   end
  #   ssh.loop
  # end

  def create_instances(instances_types, *parameters)
    puts 'in creating instance block'
    #parameters[0].store(:username, username)
    #puts parameters[0]
    parameters = parameters[0]
    instances_types.each do |instance_type|
      parameters.store(:flavor_id, instance_type)
      puts 'creating machine'
      machine = @provider.servers.bootstrap(parameters)
      machine_id = @provider.servers.get(machine.id)
      name = ("#{@provider_name}:" + instance_type).to_s.split('=>')
      vm = VirtualMachine.new(machine_id.public_ip_address, parameters[:username], :keys => parameters[:private_key_path])
      vm.wait_for_sshable
      @virtual_machines.store(name.last, vm)
    end
  end

  def destroy
    @virtual_machines.each { |instance| instance.destroy }
  end

end