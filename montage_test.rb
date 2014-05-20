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
    manual('kali', '192.168.1.116', 'root', :password => 'toor', :port => 22)
  end
  foreach ['kali'] do |instance|
    on instance do
      before 'install prerequisites' do
        ssh "curl -O http://pegasus.isi.edu/montage/Montage_v3.3_patched_4.tar.gz"
        ssh "tar zxvf Montage_v3.3_patched_4.tar.gz"
        ssh "cd Montage_v3.3_patched_4"
        ssh "make"
        ssh "cd .."
        ssh "git clone https://github.com/dice-cyfronet/hyperflow.git --depth 1 -b develop"
        ssh "cd hyperflow"
        ssh "npm install"
        ssh "curl -O https://dl.dropboxusercontent.com/u/81819/hyperflow-amqp-executor.gem"
        ssh "echo toor | sudo -S gem install --no-ri --no-rdoc hyperflow-amqp-executor.gem"
      end
      foreach [2, 4, 8] do |cores|
        before 'init amqp and deamon' do
          ssh "cd hyperflow"
          ssh "echo  \"amqp_url: amqp://localhost\nstorage: local\nthreads: <%= Executor::cpu_count %>\" > executor_config.yml"
          ssh "hyperflow-amqp-executor executor_config.yml"
        end
        before 'bootstrap script' do
          ssh "mkdir data"
          ssh "cd data"
          ssh "wget https://gist.github.com/kfigiela/9075623/raw/dacb862176e9d576c1b23f6a243f9fa318c74bce/bootstrap.sh"
          ssh "chmod +x bootstrap.sh"
        end
        foreach [0.25, 0.40] do |param|
          before 'execute bootstrap script' do
              ssh "./bootstrap.sh #{param}"
          end
          concurrent do
              execute 'generate image' do
                ssh "nodejs ~/Pulpit/cloud-experiment/treeBuilding/hyperflow/scripts/runwf.js -f  ~/Pulpit/cloud-experiment/treeBuilding/data/#{param}/workdir/dag.json -s"
              end
              execute 'other computations' do
                ssh "nodejs ~/Pulpit/cloud-experiment/treeBuilding/hyperflow/scripts/runwf.js -f  ~/Pulpit/cloud-experiment/treeBuilding/data/#{param}/workdir/dag.json -s"
              end
          end
          after 'clean up params' do
              ssh "cp  -r ./#{param}/input ./output"
              ssh "rm -rf ./#{param}"
          end
        end
        after 'clean up' do
          ssh "rm -rf data"
        end
      end
    end
  end
end

$root.run(nil)
