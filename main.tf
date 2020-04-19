provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "example" {
  ami                    = "ami-085925f297f89fce1"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.instance.id}"]

  # user_data = <<-EOF
  #             #!/bin/bash
  #             echo "Hello, World" > index.html
  #             nohup busybox httpd -f -p 8080 &
  #             EOF

  user_data = "${file("userdata.sh")}"
  tags = {
    Name = "terraform-example"
  }
}

resource "aws_security_group" "instance" {
  name        = "terraform-example-instance"
  description = "Open port 8080"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
