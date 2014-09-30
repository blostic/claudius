
# Distributed app
# ---------
# Set up distributed key-value store Etcd using Docker.
#

require "claudius"
config = load_config('./user_config.json')
$discovery_token = "https://discovery.etcd.io/c4c7919104cbf432d2a92036cddd8d33"

execution_tree = experiment 'Hello' do
  define_providers do
    cloud('aws',  :provider => config['provider'],
          :region =>config['region'],
          :endpoint => 'https://ec2.eu-west-1.amazonaws.com/',
          :aws_access_key_id => config['aws_access_key_id'],
          :aws_secret_access_key => config['aws_secret_access_key'])
    .create_instances(
        ['t1.micro=>in1'],
                      :username => 'ubuntu',
                      :private_key_path =>config['path_to_pem_file'],
                      :key_name => config['key_name'],
                      :image_id => 'ami-b84deccf',
                      :groups => config['groups'])
  end
  foreach ['in1', 'in2'] do |instance_name|
      on instance_name do
        before "set up docker" do
          ssh "curl -sSL https://get.docker.io/ubuntu/ | sudo sh"
          ssh "sudo apt-get install git -y"
          ssh "wget https://github.com/coreos/etcd/archive/v0.4.6.tar.gz"
          ssh "tar xzvf v0.4.6.tar.gz"
          ssh "mv etcd-0.4.6 /etcd"
          ssh "rm v0.4.6.tar.gz"
        end
        execute do
          ssh "sudo docker build  -t etcd /etcd"
          ssh "sudo docker run --name etcd1 -d -p 4001:4001 -p 7001:7001 -v /data/etcd1:/etcd-data etcd -name #{instance_name} -peer-addr #{getOtherInstances(instance_name).hosts}:7001 -addr #{getInstance(instance_name).host}:4001 -discovery %s" % $discovery_token
        end
        after "clean up docker containers" do
          ssh "docker stop $(docker ps -a -q)"
          ssh "docker rm $(docker ps -a -q)"
        end
      end
  end
end

ap execution_tree.run