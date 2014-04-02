require './benchmark'

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

		#install do 
		#	package("nodejs", "ppa:chris-lea/node.js")
		#end
		
		initiate do
			`mkdir tests`
		end

		experiment "Montage" do

			parameters do 
				parameter("time", 1..20)
				parameter("size", 2..5)
			end
		
			before do 
				`mkdir ./tests/test_d`
			end
			
			after do 
				`rm -rf ./tests/test_d`
			end
			
			execute do 
				puts `ls -al`
			end

		end

		clean do 
			`rm -rf ./tests`
		end

	end
end



