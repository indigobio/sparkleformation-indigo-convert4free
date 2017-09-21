SparkleFormation.dynamic(:auto_scaling_group) do |_name, _config = {}|

  parameters("#{_name}_min_size".to_sym) do
    type 'Number'
    min_value _config.fetch(:min_size, 0)
    default _config.fetch(:min_size, 0)
    description "The minimum number of instances to maintain in the #{_name} auto scaling group"
    constraint_description "Must be a number #{_config.fetch(:min_size, 1)} or higher"
  end

  parameters("#{_name}_desired_capacity".to_sym) do
    type 'Number'
    min_value _config.fetch(:desired_capacity, 1)
    default _config.fetch(:desired_capacity, 1)
    description "The desired number of instances to maintain in the #{_name} auto scaling group"
    constraint_description "Must be a number #{_config.fetch(:min_size, 1)} or higher"
  end

  parameters("#{_name}_max_size".to_sym) do
    type 'Number'
    max_value _config.fetch(:max_size, 100)
    default _config.fetch(:max_size, 1)
    description "The minimum number of instances to maintain in the #{_name} auto scaling group"
    constraint_description "Must be a number #{_config.fetch(:min_size, 100)} or lower"
  end

  dynamic!(:auto_scaling_auto_scaling_group, _name).properties do
    availability_zones get_azs!
    min_size ref!("#{_name}_min_size".to_sym)
    desired_capacity ref!("#{_name}_desired_capacity".to_sym)
    max_size ref!("#{_name}_max_size".to_sym)
    v_p_c_zone_identifier _config[:subnet_ids]
    launch_configuration_name ref!(_config[:launch_config])
    if _config.has_key?(:load_balancers)
      load_balancer_names _array(*_config[:load_balancers])
    end
    tags _array(
           -> {
             key 'Name'
             value "#{_name}_asg_instance".to_sym
             propagate_at_launch 'true'
           },
           -> {
             key 'Environment'
             value ENV['environment']
             propagate_at_launch 'true'
           }
         )
  end

  dynamic!(:auto_scaling_auto_scaling_group, _name).creation_policy do
    resource_signal do
      count ref!("#{_name}_desired_capacity".to_sym)
      timeout "PT1H"
    end
  end

  dynamic!(:auto_scaling_auto_scaling_group, _name).depends_on "#{_name.capitalize}AutoScalingLaunchConfiguration"
end
