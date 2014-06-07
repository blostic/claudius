
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
    .create_instances(['t1.micro=>in1'],
                      :username => 'ubuntu',
                      :private_key_path =>'./Piotr-key-pair-irleand.pem',
                      :key_name => 'Piotr-key-pair-irleand',
                      :groups => ['Piotr-irleand'])
    manual('kali', '172.16.0.109', 'root', :password => 'toor')
  end
  foreach ['kali', 'in1'] do |instance_name|
    concurrent do
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
end

ap execution_tree.run
execution_tree.export_tree('tree')