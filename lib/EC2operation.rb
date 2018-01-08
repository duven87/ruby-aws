class EC2operation

  def initialize(reg)
      @@ec2_c   = Aws::EC2::Client.new(region: reg)
      @@ec2     = Aws::EC2::Resource.new(region: reg)
  end

  def describeInstances
    @describe_instances_result = @@ec2_c.describe_instances
    @n = 0
    @describe_instances_result.reservations.each do |reservation|
        reservation.instances.each do |i| if reservation.instances.count > 0
          @n += 1
          if i.tags.count > 0
            i.tags.each do |tag| if tag.key == "Name"
                @name = tag.value
            end
          end
        end
        puts "#{"%3d"%[@n]} | #{"%-10s"%[@name]}  | ID = #{i.instance_id} | STATE = #{"%-13s"%[i.state.name]}  | PublicIP = #{i.public_ip_address}"
        end
        @name = nil
      end
    end
  end

  def parameters(struct)
    params = Hash.new
    a_params = Array.new
    struct.ec2.each do |ec_2|
      ec_2.instance.each do |instance|
        instance.params.each do |param|
          param.instance_variable_get("@table").keys.each do |key|
            if key == :placement
              params[key] = {
                              "availability_zone" =>                 param[key][0].availability_zone
                            }.to_h

            elsif key == :security_group_ids
              params[key] = [param[key]]

            elsif key == :tag_specifications
              params[key] = []
              params[key][0] = { "resource_type" => "instance", "tags" => []}
              ntag = 0
              param.tag_specifications.each do |os_tags|
                params[key][0]["tags"][ntag] = {}
                os_tags.tags.each do |os_t|
                  if not os_t.key.nil?
                    params[key][0]["tags"][ntag]["key"] = os_t.key
                  elsif not os_t.value.nil?
                    params[key][0]["tags"][ntag]["value"] = os_t.value
                  end
                end
                ntag += 1
              end
            else
              params[key] = param[key]
            end
          end
        end
      end
      a_params << params
      params = {}
    end
    pp a_params
    a_params
  end

  def createInstance (params)
    instances = @@ec2.create_instances(params)
    puts "creating instances... "
  end

  def stopInstances (instancesId)
    @@ec2_c.stop_instances({ instance_ids: instancesId })
    puts "Stopping instances #{instancesId}"
  end

  def startInstances (instancesId)
    @@ec2_c.start_instances({ instance_ids: instancesId })
    puts "Starting instances #{instancesId}"
  end

  def terminateInstance(instanceId)
    i = @@ec2.instance(instanceId)
    if i.exists?
      case i.state.code
        when 48 # terminated
          puts "#{i.id} is already terminated"
        else
          i.terminate
          puts "Terminating #{instanceId}"
        end
      end
    end

end
