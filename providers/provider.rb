require './providers/virtual_machine.rb'
def provider (&block)
  yield
end

def manual(name, host, username, *args)
  tmp = VirtualMachine.new(name, host, username, *args)
  tmp.invoke [['sleep 3'], ['sleep 4', 'sleep 4', 'sleep 4', 'sleep 4', 'sleep 4'], ['sleep 3', 'sleep 3']]
  tmp.invoke [['sudo /etc/init.d/mysql start']]
end
