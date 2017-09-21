SparkleFormation.new('convert4free').load(:base, :win2k8_ami, :ssh_key_pair, :git_rev_outputs).overrides do
  description <<"EOF"
MZConvert EC2 instance. ELB. Route53 record: convert4free.#{ENV['public_domain']}.
EOF

  ENV['sg']                 ||= 'private_sg'
  ENV['lb_name']            ||= "#{ENV['org']}-#{ENV['environment']}-convert4free-elb"
  ENV['rdp_ip']             ||= "127.0.0.1/32"

  parameters(:vpc) do
    type 'String'
    default registry!(:my_vpc)
    allowed_values array!(registry!(:my_vpc))
  end

  dynamic!(:iam_instance_profile, 'convert4free')

  dynamic!(:vpc_security_group, 'convert4free',
           :ingress_rules =>
             [
               { :cidr_ip => '0.0.0.0/0', :ip_protocol => 'tcp', :from_port => '80', :to_port => '80' },
               { :cidr_ip => ENV['rdp_ip'], :ip_protocol => 'tcp', :from_port => '3389', :to_port => '3389' }
             ]
           )


  dynamic!(:elb, 'convert4free',
           :listeners => [
             { :instance_port => '80', :instance_protocol => 'http', :load_balancer_port => '80', :protocol => 'http' },
             { :instance_port => '3389', :instance_protocol => 'tcp', :load_balancer_port => '3389', :protocol => 'tcp' }
           ],
           :policies => [ ],
           :security_groups => _array( attr!(:convert4free_ec2_security_group, 'GroupId') ),
           :idle_timeout => '600',
           :subnets => registry!(:my_private_subnet_ids),
           :lb_name => ENV['lb_name']
  )

  dynamic!(:launch_config, 'convert4free',
           :iam_instance_profile => 'Convert4freeIAMInstanceProfile',
           :iam_role => 'Convert4freeIAMRole',
           :create_ebs_volumes => false,
           :volume_count => ENV['volume_count'].to_i,
           :volume_size => ENV['volume_size'].to_i,
           :security_groups => _array( attr!(:convert4free_ec2_security_group, 'GroupId') )
          )

  dynamic!(:auto_scaling_group, 'convert4free',
           :launch_config => :convert4free_auto_scaling_launch_configuration,
           :subnet_ids => registry!(:my_private_subnet_ids),
           :load_balancers => _array(ref!(:convert4free_elastic_load_balancing_load_balancer))
          )

  dynamic!(:record_set, 'convert4free',
           :record => 'convert4free',
           :target => :convert4free_elastic_load_balancing_load_balancer,
           :domain_name => ENV['public_domain'],
           :attr => 'CanonicalHostedZoneName',
           :ttl => '60'
  )
end
