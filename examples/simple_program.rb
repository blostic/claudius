require 'awesome_print'
# Initiate experiment
# ---------
#
# Getting started Claudius is extremely simple. First example illustrates how to perform experiment which writes Hello World! to TestFile in your current directory
#
# To use the DSL in your code, please require the gem:
require 'claudius'
# We sepcified te __experiment__ with name "Hello". Tree which represents our experiment was returned after parse DSL.
execution_tree =
experiment 'Hello Experiment' do
  before do
    ssh "echo $PATH"
  end

# __execute__ is a block where we can specify particular commands.
  execute do
# Each starts with __ssh__ following by string represets command.
    ssh "echo Hello World! > TestFile"
  end
end

# execute tree and print result time
ap execution_tree.run
# export tree to tree.png and tree.dot
execution_tree.export_tree('tree')
