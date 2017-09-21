SparkleFormation.component(:win2k8_ami) do
  mappings(:region_to_ami) do
    set!('us-east-1'.disable_camel!, :ami => 'ami-5303ea29')
    set!('us-east-2'.disable_camel!, :ami => 'ami-7e82a01b')
    set!('us-west-1'.disable_camel!, :ami => 'ami-3c54655c')
    set!('us-west-2'.disable_camel!, :ami => 'ami-1de61a65')
  end
end
