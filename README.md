# Claudius

Claudius is a easy-to-use domain specific language for clouds experiments. Language is build on [fog.io](http://fog.io), which enables flexible and powerfull way to manage virtual machine instances on various cloude poviders. Connections with virtual machines is based on ssh. To provide information experiment flow, DSL generates readable graph of execution.

## Installation

Add this line to your application's Gemfile:

    gem 'claudius'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install claudius

## Usage

To use the DSL in your code, please require the gem:

```ruby
require 'claudius'
``` 

Basic Usage
---------

Initiate experiment
---------
Getting started Claudius is extremely simple. First example illustrates how to perform experiment which writes Hello World! to TestFile in your current directory

```ruby
require 'claudius'
experiment 'Hello' do
execute do
		ssh "echo Hello World! > TestFile"
	end
end
```

Specify instances
---------
To conduct an experiment remotely, You should define set of machines, which you would like to use. Claudius allows you to define 2 types of hosts - ones which are going to be created in clouds environment, and others which are already established (and you have access to them). To define machine and to maintain connection with them you should provide required parameters. For your convenience, you may store all yours parameters in json file, and recall them as it is presented in example.

```ruby
require 'claudius'
config = load_config('./user_config.json')
experiment 'Hello' do
	define_providers do 
	    cloud('aws',  :provider => config['provider'],
	                  :region =>config['region'],
	                  :endpoint => 'https://ec2.eu-west-1.amazonaws.com/',
	                  :aws_access_key_id => config['aws_access_key_id'],
	                  :aws_secret_access_key => config['aws_secret_access_key'])
	    .create_instances(['t1.micro=>in1'],
	                  :username => 'ubuntu',
	                  :private_key_path =>'./Piotr-key-pair-irleand.pem',
	                  :key_name => 'Piotr-key-pair-irleand',
	                  :groups => ['Piotr-irleand'])
	    manual('kali', '172.16.0.109', 'root', :password => 'toor')
  	end
  	foreach ['kali', 'in1'] do |instance|
		on instance do
			execute do
				ssh "echo Hello World! > TestFile"
			end
		end
	end
end
```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
