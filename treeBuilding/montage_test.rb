require './foreach.rb'

experiment 'Montage' do
	foreach ['instance 1', 'instance 2'], safely do |instance|
		foreach [2, 4, 8] do |cores|
			on instance do
				before do
					`echo  "amqp_url: amqp://localhost 
					 storage: local 
					 threads: <%= Executor::#{cores}%>" > executor_config.yml`
				end
				before "deamon", asynchronously do 
					# `hyperflow-amqp-executor executor_config.yml`
				end
				foreach [0.25, 0.4, 0.75] do |param|
					before do
						`mkdir data; cd data`
						`curl -O https://gist.github.com/kfigiela/9075623/raw/dacb862176e9d576c1b23f6a243f9fa318c74bce/bootstrap.sh`
						`chmod +x bootstrap.sh; ./bootstrap.sh #{param}` 
					end
					execute do
						`nodejs ~/hyperflow/scripts/runwf.js -f  ~/data/#{param}/workdir/dag.json -s`
					end
					after do 
						`rm -rf data`
					end
				end
			end
		end
	end			
end
