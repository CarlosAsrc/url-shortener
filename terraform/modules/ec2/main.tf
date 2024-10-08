resource "aws_launch_template" "ecs_lt" {
  name_prefix   = "ecs-template"
  image_id      = "ami-0c45946ade6066f3d"
  instance_type = var.instance_type

  key_name               = "teste-kp"
  vpc_security_group_ids = var.security_groups
  iam_instance_profile {
    arn = var.instance_profile
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 30
      volume_type = "gp2"
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "ecs-instance"
    }
  }


  user_data = base64encode(<<-EOF
    #!/bin/bash
    echo ECS_CLUSTER=${var.ecs_cluster_name} >> /etc/ecs/ecs.config
    yum install -y awslogs
    service awslogs start
    chkconfig awslogs on
  EOF
  )
}

resource "aws_autoscaling_group" "ecs_asg" {
  vpc_zone_identifier = var.private_subnets
  desired_capacity    = var.desired_count
  min_size            = var.min_count
  max_size            = var.max_count

  launch_template {
    id      = aws_launch_template.ecs_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "AmazonECSManaged"
    value               = true
    propagate_at_launch = true
  }
}
