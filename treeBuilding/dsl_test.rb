require './functions.rb'



Module.providers({});
Module.db();
Module.tree(tree);
Module.exec();

experiment 'experiment_name' do   
    before do
        puts "This should be displayed only once, at the beginning"
    end
    foreach [1, 2, 30] do |param|
        before do
            puts "Param: " + param.to_s
        end
        foreach ['fake-instance-01', 'fake-instance-02'], safely do |instance1|
            before do
                puts "Before outer instance: " + instance1
            end
            foreach ['fake-instance-11', 'fake-instance-22'] do |instance2|
                concurrent do
                    on instance1 do
                        before do
                            puts "Before on outer instance :" + instance1
                        end
                        puts "parameter: " + param.to_s + ", on instance " + instance1
                        after do
                            puts "After on outer instance :" + instance1
                        end
                    end
                    on instance2 do
                        before do
                            puts "Before on inner instance :" + instance2
                        end
                        puts "parameter: " + param.to_s + ", on instance " + instance2
                        after do
                            puts "After on inner instance :" + instance2
                        end
                    end
                end
            end
        end
    end
    after do
        puts "This should be displayed only once, at the end"
    end
end



