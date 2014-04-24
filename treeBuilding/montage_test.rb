require './foreach.rb'

experiment 'Montage' do
    puts 'Prints once when tree is building'
    before do
        puts 'Prints when tree is executing'
    end
    foreach ['instance 1', 'instance 2'] do |instance|
        puts 'Before parse `on`'
        before do
            puts "Execute on #{instance}"
        end
        on instance do
            before 'install prerequisites' do
                puts 'exec install prerequisites'
                # `curl -O http://pegasus.isi.edu/montage/Montage_v3.3_patched_4.tar.gz;
                # tar zxvf Montage_v3.3_patched_4.tar.gz; 
                # cd Montage_v3.3_patched_4; 
                # make;
                # cd ..;
                # git clone https://github.com/dice-cyfronet/hyperflow.git --depth 1 -b develop;
                # cd hyperflow;
                # npm install;
                # curl -O https://dl.dropboxusercontent.com/u/81819/hyperflow-amqp-executor.gem;
                # echo mamrchckten | sudo -S gem2.0 install --no-ri --no-rdoc hyperflow-amqp-executor.gem`
            end

            foreach [2, 4, 8] do |cores|
                hyperflow_deamon = -100
                before 'init amqp' do
                    puts 'init amqp'
                    # `echo  "amqp_url: amqp://localhost\nstorage: local\nthreads: <%= Executor::cpu_count %>" > executor_config.yml`
                end

                before 'init deamon' do
                    puts 'init deamon'
                    # hyperflow_deamon = fork do
                    #     exec "hyperflow-amqp-executor executor_config.yml"
                    # end
                    # Process.detach(hyperflow_deamon)
                end

                before 'bootstrap script' do
                    puts 'init bootstrap script'
                    # `mkdir data;
                    # cd data;
                    # wget https://gist.github.com/kfigiela/9075623/raw/dacb862176e9d576c1b23f6a243f9fa318c74bce/bootstrap.sh;
                    # chmod +x bootstrap.sh`
                end
                foreach [0.25, 0.40] do |param|
                    before 'execute bootstrap script' do
                        puts "execute bootstrap.sh #{param}"
                        # `./data/bootstrap.sh #{param}`
                    end
                    concurrent do
                        before do
                            puts 'concurrent block'
                        end
                        execute 'generate image' do
                            puts 'generate image concurrently'
                            # puts `nodejs ~/Pulpit/cloud-experiment/treeBuilding/hyperflow/scripts/runwf.js -f  ~/Pulpit/cloud-experiment/treeBuilding/data/#{param}/workdir/dag.json -s`
                        end
                        execute 'other computations' do
                            puts 'other computations concurrently'
                            # puts `nodejs ~/Pulpit/cloud-experiment/treeBuilding/hyperflow/scripts/runwf.js -f  ~/Pulpit/cloud-experiment/treeBuilding/data/#{param}/workdir/dag.json -s`
                        end
                    end
                    after 'clean up params' do
                        puts "clean up for param #{param}"
                        # `cp  -r ./#{param}/input ./output`
                        # `rm -rf ./#{param}`
                    end
                end
                after 'clean up deamon' do
                    puts 'clean up deamon'
                    # Process.kill("HUP", hyperflow_deamon)
                    #`rm -rf data`
                end
            end
        end
  end
  after do
    puts 'after experiment'
  end
end

$root.run
