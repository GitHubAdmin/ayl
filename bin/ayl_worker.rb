#!/usr/bin/env ruby
require 'optparse'
require 'rails'
require 'ayl'

BEANSTALK_HOST_DEFAULT = 'localhost'
BEANSTALK_PORT_DEFAULT = 11300
BEANSTALK_TUBE_DEFAULT = 'default'

options = {}

optparse = OptionParser.new do | opts |
  
  # Set a banner, displayed at the top of the help screen.
  opts.banner = "Usage: #{$0} [options]"

  options[:host] = BEANSTALK_HOST_DEFAULT
  opts.on '-m', '--host HOST', "Specify the host running beanstalk. Default (#{BEANSTALK_HOST_DEFAULT})." do |host|
    options[:host] = host
  end

  options[:port] = BEANSTALK_PORT_DEFAULT
  opts.on '-p', '--port PORT', "Specify the port on which beanstalk is listening. Default (#{BEANSTALK_PORT_DEFAULT}]." do |port|
    options[:port] = port
  end

  options[:tube] = BEANSTALK_TUBE_DEFAULT
  opts.on '-t', '--tube TUBE', "Specify the beanstalk tube to listen to. Default (#{BEANSTALK_TUBE_DEFAULT})." do |tube|
    options[:tube] = tube
  end

  options[:env] = 'production'
  opts.on '-e', '--environment ENVIRONMENT', "Specify the Rails environment to use" do |environment|
    options[:env] = environment
  end

  options[:app_path] = nil
  opts.on '-a', '--app-path APP_PATH', "Specify the path to the rails app" do |app_path|
    options[:app_path] = app_path
  end

  options[:rails_app] = false
  opts.on '-r', '--rails', "Indicate that we are starting a rails application" do 
    options[:rails_app] = true
  end

  opts.on '-h', '--help', 'Display the help message' do
    puts opts
    exit
  end
end

optparse.parse!

if options[:app_path].nil?
  puts "Must specify an application path"
  exit
end

ENV['RAILS_ENV'] = options[:env]

if options[:rails_app]
  require 'rails' 
  require File.join(options[:app_path], 'config/environment')
end

puts "### The Rails envionment: #{Rails.env}"

Ayl::MessageOptions.default_queue_name = options[:tube]

engine = Ayl::Engine.get_active_engine

engine.process_messages
