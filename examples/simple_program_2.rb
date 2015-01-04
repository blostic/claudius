require 'claudius'
config = load_config('./user_config.json')

execution_tree = experiment 'Hello' do
  	define_providers do
    	cloud('aws',  :provider => config['provider'],
	          :region =>config['region'],
	          :aws_access_key_id => config['aws_access_key_id'],
	          :aws_secret_access_key => config['aws_secret_access_key'])
      	.create_instances(['t1.micro=>instance1','t1.micro=>instance2','t1.micro=>instance3'],
              :username => 'ubuntu',
              :private_key_path =>config['private_key_path'],
              :key_name => config['key_name'],
              :groups => config['groups'])
	end
	foreach ['instance1','instance2','instance3'], concurrently do |instance|
	    on instance do
	        before do
	          ssh "mkdir test"
	        end
	        concurrent do
	            foreach 1..3 do |m|
	            	execute do
	                	ssh "cd test"
	               		ssh "touch testFile#{m}"
	               	end
	            end
	            execute do
	                ssh "ls"
	            end
	        end
			after do
	          ssh "rm -rf test"
	        end
	    end
	end
end

ap execution_tree.run
execution_tree.export_tree('tree')
execution_tree.destroy_machines