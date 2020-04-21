provider "aws" {
  region = "us-east-1"
}

# resource "aws_instance" "example" {
#   ami                    = "ami-085925f297f89fce1"
#   instance_type          = "t2.micro"
#   vpc_security_group_ids = [aws_security_group.instance.id]

#   # user_data = <<-EOF
#   #             #!/bin/bash
#   #             echo "Hello, World" > index.html
#   #             nohup busybox httpd -f -p 8080 &
#   #             EOF

#   # user_data = file("userdata.sh")
#   user_data = templatefile("userdata.tmpl", { port = var.server_port })
#   tags = {
#     Name = "terraform-example"
#   }
# }

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 8080
}

resource "aws_security_group" "instance" {
  name        = "terraform-example-instance"
  description = "Open port 8080"

  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# output "public_ip" {
#   value       = aws_instance.example.public_ip
#   description = "The public IP address of the web server"
# }

resource "aws_launch_configuration" "example" {
  image_id        = "ami-085925f297f89fce1"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.instance.id]

  user_data = templatefile("userdata.tmpl", { port = var.server_port })
  # user_data = <<-EOF
  #             #!/bin/bash
  #             echo "Hello, World" > index.html
  #             nohup busybox httpd -f -p ${var.server_port} &
  #             EOF

  # Required when using a launch configuration with an auto scaling group.
  # https://www.terraform.io/docs/providers/aws/r/launch_configuration.html
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "example" {
  launch_configuration = aws_launch_configuration.example.name
  vpc_zone_identifier  = data.aws_subnet_ids.default.ids

  min_size = 2
  max_size = 10

  tag {
    key                 = "Name"
    value               = "terraform-asg-example"
    propagate_at_launch = true
  }
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

resource "aws_lb" "example" {
  name               = "terraform-asg-example"
  load_balancer_type = "application"
  subnets            = data.aws_subnet_ids.default.ids
  security_groups    = [aws_security_group.alb.id]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.example.arn
  port              = 80
  protocol          = "HTTP"

  # By default, return a simple 404 page
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}

resource "aws_security_group" "alb" {
  name = "terraform-example-alb"

  # Allow inbound HTTP requests
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound requests
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# TODO: Create target group for the ASG
# Search for "you need to create a target group for your ASG"
