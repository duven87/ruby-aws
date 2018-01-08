class OptionsParse
  Version = '0.5.1'

  def self.parse(args)
    options = OpenStruct.new
    options.instances = {}
    options.encoding = "utf8"
    options.verbose = false

    opts = OptionParser.new do |opts|
      opts.banner = "Usage: ec2.rb [options]"

      opts.separator ""
      opts.separator "Available options:"

      opts.on("-r", "--region REGION", String,
             "Supply a region") do |region|
                  options.instances[:region] = region
      end

      opts.on("-c", "--create RELATIVE_PATH", Array,
                "Create the file(s) supplied") do |file|
                  options.instances[:create] ||= file
      end

      opts.on("--start INSTANCE[s]-ID", Array,
                "Start the INSTANCE[s]-ID supplied") do |id|
                options.instances[:start] ||= id
      end

      opts.on("--stop INSTANCE[s]-ID", Array,
                "Stop the INSTANCE[s]-ID supplied") do |id|
                  options.instances[:stop] ||= id
      end

      opts.on("-t", "--terminate INSTANCE-ID", String,
                "Terminate the INSTANCE-ID supplied") do |id|
                  options.instances[:terminate] = id
      end

      opts.on("-d", "--describe",
                "Describe EC2 instances in region") do
                  options.instances[:describe] ||= true
      end

    #opts.on("-g", "--autoscaling INSTANCE[s]-ID",
    #            "Show autoscaling group (if any) of the INSTANCE[s]-ID supplied") do |id|
    #              options.instances[:ag] ||= id
    #  end

    #opts.on("-u", "--userdata FILE",
    #          "Replace user data from a supplied FILE") do |f|
    #              options.instances[:userDataFile] ||= f
    #    end

      opts.on_tail("-v", "--version", "Show version") do
                  puts Version
                  exit
      end

      opts.separator ""
      opts.on_tail("-h", "--help", "Show this message") do
                  puts opts
                  exit
      end
    end
    opts.parse!(args)
    options
  end
end
