# Ping 
# ---------
# This example shows how to conduct simple experiment with ping command.
#

require 'claudius'

config = load_config('./user_config.json')

execution_tree = experiment 'Hello' do
  define_providers do
    cloud('aws',  :provider => config['provider'],
          :region =>config['region'],
          :endpoint => 'https://ec2.eu-west-1.amazonaws.com/',
          :aws_access_key_id => config['aws_access_key_id'],
          :aws_secret_access_key => config['aws_secret_access_key'])
    .create_instances(['t1.micro=>instance1', 't1.micro=>instance2', 't1.micro=>instance3'],
                      :username => 'ubuntu',
                      :private_key_path =>config['private_key_path'],
                      :key_name => config['key_name'],
                      :groups => config['groups'])
  end
  foreach ['instance1', 'instance2', 'instance3'], concurrently do |instance_name|
    on 'localhost' do
      execute do
        ssh "ping #{getInstance(instance_name).host} -c 3"
      end
    end
    on instance_name do
      execute do
        ssh "ping #{getInstance(instance_name).host} -c 3"
        ssh "echo Hello World! > TestFile"
      end
    end
  end
end

ap execution_tree.run
execution_tree.export_tree('tree')
execution_tree.destroy_machines
