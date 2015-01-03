require 'net/ssh'

def s_ssh(session, commands)
  commands.each do |command|
    session.exec(command)
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

  def ssh_test(session,command)
    res = session.exec!(command)
    puts res
    if res!='' and res!="attributes.json\n"
      @active = true
    end
  end

  def invoke(commands)
    Net::SSH.start(host, username, *args) do |ssh|
      commands.each do |command|
        print command , "\n"
        s_ssh ssh, command
      end
    end
  end

end
