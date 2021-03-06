require 'claudius'
config = load_config('./user_config.json')
experiment 'Montage' do
  define_providers do
    cloud('aws', :provider => config['provider'],
                  :region =>config['region'],
                  :endpoint => 'https://ec2.eu-west-1.amazonaws.com/',
                  :aws_access_key_id => config['aws_access_key_id'],
                  :aws_secret_access_key => config['aws_secret_access_key'])
    .create_instances(['t1.micro=>in1'],
                  :username => 'ubuntu',
                  :private_key_path =>'./Piotr-key-pair-irleand.pem',
                  :key_name => 'Piotr-key-pair-irleand',
                  :groups => ['Piotr-irleand'])
    manual('kali', '172.16.0.101', 'root', :password => 'toor', :port => 22)
  end

  foreach ['kali','in1'] do |instance|
    before do
      ssh "who"
    end
    foreach ['a', 'b', 'c'] do |param|
      before do
        ssh "who"
      end
      on instance do
      	concurrent do
          execute do
            ssh "cd ~/Desktop; mkdir test2323"
          end
          execute do
            ssh "echo #{param}"
          end
        end
      end
    end
  end
end