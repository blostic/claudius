require "claudius"
require "json"

config = load_config('./user_config.json')

execution_tree = experiment 'Helloo' do
  define_providers do
    cloud('aws',  :provider => config['provider'],
          :region =>config['region'],
          :endpoint => 'https://ec2.eu-west-1.amazonaws.com/',
          :aws_access_key_id => config['aws_access_key_id'],
          :aws_secret_access_key => config['aws_secret_access_key'])
    .create_instances(
        ['m3.medium=>in2', 'm3.large=>in3', 'c3.large=>in4', 'c3.xlarge=>in5'],
        :username => 'ubuntu',
        :private_key_path =>config['path_to_pem_file'],
        :key_name => config['key_name'],
        :image_id => config['image_id'],
        :groups => config['groups'])
  end
  foreach ['in2', 'in3', 'in4', 'in5'] do |instance_name|
    on instance_name do
      before "set up docker" do
        ssh "yes | sudo apt-get update"
        ssh "yes | sudo apt-get install build-essential"

        ssh "yes | sudo apt-get install python-software-properties python g++ make"
        ssh "yes | sudo add-apt-repository ppa:chris-lea/node.js"
        ssh "yes | sudo apt-get update"
        ssh "yes | sudo apt-get install nodejs"

        ssh "yes | sudo apt-get install git-core"

        ssh "yes | sudo apt-get -y install build-essential zlib1g-dev libssl-dev libreadline6-dev libyaml-dev"
        ssh "yes | sudo apt-get install ruby2.0 ruby2.0-dev build-essential libxml2-dev libxslt1-dev"
        ssh "yes | sudo apt-get install rabbitmq-server"
        ssh "yes | sudo apt-get install redis-server"

        ssh "echo 'Git:'"
        ssh "git --version"
        ssh "echo 'Ruby'"
        ssh "ruby --version"
        ssh "echo 'Nodejs'"
        ssh "nodejs --version"
        ssh "echo 'Redis'"
        ssh "redis-server --version"

        ssh "curl -O http://pegasus.isi.edu/montage/Montage_v3.3_patched_4.tar.gz"
        ssh "tar zxvf Montage_v3.3_patched_4.tar.gz"
        ssh "cd Montage_v3.3_patched_4 && make"

        ssh "curl -O https://dl.dropboxusercontent.com/u/81819/hyperflow-amqp-executor.gem"
        ssh "sudo gem2.0 install --no-ri --no-rdoc hyperflow-amqp-executor.gem"

        ssh "wget https://github.com/dice-cyfronet/hyperflow/archive/v1.0.0-beta-6.tar.gz"
        ssh "tar zxvf v1.0.0-beta-6.tar.gz"
        ssh "mv hyperflow-1.0.0-beta-6 hyperflow"
        ssh "cd hyperflow && npm install"

        ssh "cd hyperflow && echo 'amqp_url: amqp://localhost\nstorage: local\nthreads: <%= Executor::cpu_count %>' > executor_config.yml"

        ssh "mkdir data"
        ssh "cd data && wget https://gist.github.com/kfigiela/9075623/raw/dacb862176e9d576c1b23f6a243f9fa318c74bce/bootstrap.sh"
        ssh "cd data && chmod +x bootstrap.sh"

      end
      foreach [1, 2, 3] do |a|
        foreach [0.1, 0.25, 0.4] do |size|
          execute do

            ssh "export PATH=$PATH:~/Montage_v3.3_patched_4/bin && ./data/bootstrap.sh #{size}#{a}"

            ssh "cd hyperflow && echo \"var AMQP_URL=process.env.AMQP_URL?process.env.AMQP_URL:'amqp://localhost:5672';exports.amqp_url=AMQP_URL;exports.options={'storage':'local','workdir':'/home/ubuntu/#{size}#{a}/input'}\" > functions/amqpCommand.config.js"

            ssh "export PATH=$PATH:~/Montage_v3.3_patched_4/bin; nohup hyperflow-amqp-executor $(pwd)/hyperflow/executor_config.yml > amqp.out 2>&1 &"
            ssh "nodejs hyperflow/scripts/dax_convert_amqp.js #{size}#{a}/workdir/dag.xml > #{size}#{a}/workdir/dag.json"
            # ssh "nohup nodejs hyperflow/scripts/runwf.js -f #{size}/workdir/dag.json -s > amqp.out 2>&1 &"
          end
        end
      end
    end
  end
end

result = execution_tree.run
ap result

puts result.to_json