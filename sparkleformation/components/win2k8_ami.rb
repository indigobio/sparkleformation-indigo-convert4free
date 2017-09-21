SparkleFormation.component(:win2k8_ami) do
  mappings(:region_to_ami) do
    set!('us-east-1'.disable_camel!, :ami => 'ami-3150b94b')
    set!('us-east-2'.disable_camel!, :ami => 'ami-1981a37c')
    set!('us-west-1'.disable_camel!, :ami => 'ami-e65f6e86')
    set!('us-west-2'.disable_camel!, :ami => 'ami-e6c73b9e')
  end
end
