require 'cloudmate'

config = load_config('./user_config.json')

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
  before do
    ssh "id"
  end
  after do
    ssh "ls"
  end
  foreach ['kali', 'next'], asynchronously do |instance|
     before do
       ssh "who"
     end
    on instance do
      before do
        ssh "ps -aux"
      end
      after do
        ssh "cat \"file.txt\""
      end

      concurrent do
        execute do
          i = 0
          while (i < 2)
            ssh "date"
            i += 1
          end
        end
        execute do
          i = 2
          while (i < 5)
            ssh "ls"
            i += 1
          end
        end
      end
    end
  end
end
#$root.run(0, nil)
$root.print_tree
