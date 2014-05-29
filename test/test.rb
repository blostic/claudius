require 'cloudmate'

experiment 'sdsdf' do
  define_providers do
    # cloud('aws', :provider => config['provider'],
    #               :region=>config['region'],
    #               :aws_access_key_id => config['aws_access_key_id'],
    #               :aws_secret_access_key => config['aws_secret_access_key'])
    # .create_instances(['t1.micro'], 'ubuntu', './Piotr-key-pair-irleand.pem',
    #               :key_name => 'Piotr-key-pair-irleand',
    #               :groups => 'Piotr-irleand')
    manual('kali', '172.16.133.128', 'root', :password => 'toor', :port => 22)
  end

end

#   puts 'Prints once when tree is building'
#   foreach ['kali'] do |instance|
#     foreach ['a'] do |param|
#       before do
#       end
#       on instance do
#         before 'install prerequisites' do
#           ssh "curl -O http://pegasus.isi.edu/montage/Montage_v3.3_patched_4.tar.gz"
#           ssh "tar zxvf Montage_v3.3_patched_4.tar.gz"
#           ssh "cd Montage_v3.3_patched_4"
#           ssh "make"
#           ssh "cd .."
#           ssh "git clone https://github.com/dice-cyfronet/hyperflow.git --depth 1 -b develop"
#           ssh "cd hyperflow"
#           ssh "npm install"
#           ssh "curl -O https://dl.dropboxusercontent.com/u/81819/hyperflow-amqp-executor.gem"
#           ssh "echo toor | sudo -S gem2.0 install --no-ri --no-rdoc hyperflow-amqp-executor.gem"
#         end
#         concurrent do
#           execute do
#             ssh "date"
#           end
#           execute do
#             ssh "echo #{param}"
#           end
#         end
#       end
#       after do
#       end
#     end
#   end
# end
#
# $root.run(nil)