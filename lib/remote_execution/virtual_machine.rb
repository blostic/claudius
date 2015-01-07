require 'net/ssh'

def s_ssh(session, commands)
  commands.each do |command|
    session.exec(command)
  end
  session.loop
end

class VirtualMachine
  attr_accessor :ip_address, :username, :args, :log_file, :active

  def initialize(ip_address, username, *args)
    @ip_address = ip_address
    @username = username
    args[0].store(:timeout, 5)
    @args = args
    @active = false
  end

  def to_s
    "[IP: #{ip_address}, user: #{username}]"
  end

  def ssh_test(session,command)
    res = session.exec!(command)
    puts res
    if res!='' and res!="attributes.json\n"
      @active = true
    end
  end

  def invoke(commands)
    Net::SSH.start(ip_address, username, *args) do |ssh|
      commands.each do |command|
        print command , "\n"
        s_ssh ssh, command
      end
    end
  end

end
