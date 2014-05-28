require 'net/ssh'

# # Asynchronous ssh - function invokes commands on remote host.
# # Commands are invoked in separate session.
#

def s_ssh(session, commands)
  commands.each do |command|
    session.exec command
  end
  session.loop
end

class VirtualMachine
  attr_accessor :host, :username, :args, :log_file, :active

  def initialize(host, username, *args)
    @host = host
    @username = username
    args[0].store(:timeout, 5)
    @args = args
    @active = false
  end

  def to_s
    "[host: #{host}, user: #{username}]"
  end

  def p_ssh(session, command)
    session.open_channel do |channel, success|
      print success
      #abort "could not execute command" unless success
      channel.exec command do |ch, success|
        channel.on_data do |ch, data|
          puts data,'E'
          if data != "attributes.json\n"
            @active = true
          end
        end
      end
    end
  end

  def t_ssh(session, command)
    puts session.exec command
    @active = true
  end

  def invoke(commands)
    Net::SSH.start(host, username, *args) do |ssh|
      commands.each do |command|
        print command , "\n"
        s_ssh ssh, command
      end
    end
  end

  def wait_for_sshable
    puts 'start'
    puts @active
    i = 0
    while (i<120) do
      sleep(1)
      print i,' '
      i += 1
    end
    puts 'machine available'
    # while !@active do
    #   print '>.'
    #   begin
    #     Net::SSH.start(@host, @username, *args) do |ssh|
    #       t_ssh ssh, 'ls'
    #     end
    #   rescue Timeout::Error
    #     @error = "Timed out"
    #   rescue Errno::EHOSTUNREACH
    #     @error = "Host unreachable"
    #   rescue Errno::ECONNREFUSED
    #     sleep(1)
    #     @error = "\nConnection refused"
    #     puts @error
    #   rescue Net::SSH::AuthenticationFailed
    #     @error = "Authentication failure"
    #   end
    # end
  end

end
