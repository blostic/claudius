
# Initiate experiment
# ---------
#
# Getting started Claudius is extremely simple. First example illustrates how to perform experiment which writes Hello World! to TestFile in your current directory
#
# To use the DSL in your code, please require the gem:
require 'claudius'
# We sepcified te __experiment__ with name "Hello". Tree which represents our experiment was returned after parse DSL.
execution_tree = experiment 'Hello' do
# __execute__ is a block where we can specify particular commands.
execute do
# Each starts with __ssh__ following by string represets command.
		ssh "echo Hello World! > TestFile"
	end
end
