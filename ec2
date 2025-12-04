resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow HTTP"
  vpc_id      = module.network.vpc_id

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  ami           = "ami-0c768662cc797cd75" # AP-South-1 Amazon Linux 2
  instance_type = "t2.micro"
  subnet_id     = module.network.public_a

  security_groups = [aws_security_group.web_sg.id]

  user_data = <<EOF
#!/bin/bash
yum update -y
yum install nginx -y
systemctl enable nginx
systemctl start nginx
echo "<h1>My Resume Website</h1>" > /usr/share/nginx/html/index.html
EOF

  tags = {
    Name = "resume-server"
  }
}
