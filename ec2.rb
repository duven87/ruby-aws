Dir[File.join(File.dirname(__FILE__), 'lib', '*.rb')].each {|file| require file }
require 'aws-sdk'
require 'aws-sdk-ec2'
require 'optparse'
require 'ostruct'
require 'yaml'
require 'json'
require 'ostruct'
require 'pp'

options = OptionsParse.parse(ARGV)
Aws.config[:profile] = 'default'

if options.instances[:region]
  region = options.instances[:region]
elsif ENV['AWS_REGION']
  region = ENV['AWS_REGION']
else
  region = 'eu-west-1'
end
ec2do = EC2operation.new(region)

if options.instances[:create]
  relative = options.instances[:create]
  relative.each do |dir|
    Dir[File.join(File.dirname(__FILE__), dir, '*.yml')].each do |f|
      json = YAML.load_file(File.new(f)).to_json
      @ostruct = JSON.parse(json, object_class: OpenStruct)
    end
    params = ec2do.parameters(@ostruct)
    params.each do |p|
      ec2do.createInstance(p)
    end
  end
end

if options.instances[:describe]
  ec2do.describeInstances
  puts '-'*10
  puts region
end

if options.instances[:start]
  instances_id = options.instances[:start]
  ec2do.startInstances(instances_id)
end

if options.instances[:stop]
  instances_id = options.instances[:stop]
  ec2do.stopInstances(instances_id)
end

if options.instances[:terminate]
  instance_id = options.instances[:terminate]
  ec2do.terminateInstance(instance_id)
end
