require './experiment'

benchmark "Montage" do

	providers do
		provider "AWS" do
			aws_access_key_id 		ENV['EC2_ACCESS_KEY']
			#aws_secret_access_key 	ENV['EC2_SECRET_KEY']
			#endpoint 				'https://ec2.eu-west-1.amazonaws.com/'
			instances 't1.micro', 'm1.small'
		end
	end

	experiments do

		install do 
			package("nodejs", "ppa:chris-lea/node.js")
		end
		
		initiate do
			`mkdir tests`
		end

		parameters do 
			parameter("time", 1..20)
			parameter("size", 2..5)
		end
		
		experiment "Montage" do

			beforeEach do 
				`mkdir ./tests/test_d`
			end
			
			execution do 
				puts `ls -al`
			end

			afterEach do 
				`rm -rf ./tests/test_d`
			end
			
		end

		clean do 
			`rm -rf ./tests`
		end

	end
end



