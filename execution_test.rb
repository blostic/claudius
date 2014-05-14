require './treeBuilding/tree_execution_builder.rb'
require './remote_execution/provider.rb'

config = load_user_lib('./user_config.json')

experiment 'Montage' do
  define_providers do
    # cloud('aws', :provider => config['provider'],
    #               :region=>config['region'],
    #               :aws_access_key_id => config['aws_access_key_id'],
    #               :aws_secret_access_key => config['aws_secret_access_key'])
    # .create_instances(['t1.micro'], 'ubuntu', './Piotr-key-pair-irleand.pem',
    #               :key_name => 'Piotr-key-pair-irleand',
    #               :groups => 'Piotr-irleand')
    manual('kali', '172.16.0.104', 'root', :password => 'toor', :port => 22)
  end


  puts 'Prints once when tree is building'
  foreach ['kali'], asynchronously do |instance|
     before do
       ssh "who"
     end
    on instance do
      concurrent do
        execute do
          i = 1
          while (i < 3)
            ssh "date"
            i += 1
          end
        end
        execute do
          i = 1
          while (i < 3)
            ssh "ls"
            i += 1
          end
        end
      end
    end
  end
end

$root.run(0, nil)
$root.run(0, nil)
