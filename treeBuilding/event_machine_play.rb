#!/usr/bin/ruby

require 'rubygems'
require 'eventmachine'

class Server < EventMachine::Connection
  attr_accessor :options, :status

  def receive_data(data)
    puts "#{@status} -- #{data}"
    send_data("helo\n")
  end
end

EM.run do
  EM.start_server 'localhost', 8080, Server do |conn|

    conn.options = {:my => 'options'}
    conn.status = :OK
  end
end
