require 'net/ssh'

module Cloudmate

  # # Asynchronous ssh - function invokes commands on remote host.
  # # Commands are invoked in separate session.
  #
  # def p_ssh(session, commands)
  #   commands.each do |command|
  #     session.open_channel do |channel|
  #       channel.exec command
  #       channel.on_data do |ch, data|
  #         puts "[#{command}] ->\n#{data}"
  #       end
  #     end
  #   end
  #   session.loop
  # end



  def s_ssh(session, commands)
    commands.each do |command|
      session.exec command
    end
    session.loop
  end

  class VirtualMachine
    attr_accessor :name, :host, :username, :args, :log_file

    def initialize(name, host, username, *args)
      @name = name
      @host = host
      @username = username
      @args = *args
    end

    def to_s
      "[name: #{name}, host: #{host}, user: #{username}]"
    end

    def invoke commands
      Net::SSH.start(host, username, *args) do |ssh|
        commands.each do |command|
          print command , "\n"
          s_ssh ssh, command
        end
      end
    end
  end

end