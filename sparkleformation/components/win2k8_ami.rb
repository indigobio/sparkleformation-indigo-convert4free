SparkleFormation.component(:win2k8_ami) do
  mappings(:region_to_ami) do
    set!('us-east-1'.disable_camel!, :ami => 'ami-405c913a')
    set!('us-east-2'.disable_camel!, :ami => 'ami-a18ba6c4')
    set!('us-west-1'.disable_camel!, :ami => 'ami-5acdfe3a')
    set!('us-west-2'.disable_camel!, :ami => 'ami-86a96efe')
  end
end
