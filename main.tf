provider "aws" {
}

terraform {
  default = "eu-east-1"
}

# EC2 instance resources
resource "aws_instance" "webserver1" {
  ami           = "ami-005f9685cb30f234b"
  instance_type = "t2.micro"
  subnet_id     = "subnet-085ecd58410dc966c"
  key_name      = "test_key"
  vpc_security_group_ids = ["sg-08df8158c7b20d46c"]

  user_data = <<-EOF
  #!/bin/bash
  sudo yum update -y
  sudo yum install httpd -y
  sudo systemctl start httpd
  sudo systemctl enable httpd
  sudo echo "My first fockin instance works fine!!!" >> /var/www/html/index.html
  EOF
}

resource "aws_instance" "webserver2" {
  ami           = "ami-005f9685cb30f234b"
  instance_type = "t2.micro"
  subnet_id     = "subnet-085ecd58410dc966c"
  key_name      = "test_key"
  vpc_security_group_ids = ["sg-08df8158c7b20d46c"]

  user_data = <<-EOF
  #!/bin/bash
  sudo yum update -y
  sudo yum install httpd -y
  sudo systemctl start httpd
  sudo systemctl enable httpd
  sudo echo "Aand my second fockin instance works fine!!!" >> /var/www/html/index.html
  EOF
}

resource "aws_lb" "lb1" {
  name               = "lb1"
  internal           = false
  load_balancer_type = "application"
  subnets = ["subnet-085ecd58410dc966c"]
  security_groups = ["sg-0362be82d370c2f38"]
}

resource "aws_lb_target_group" "tg1" {
  vpc_id             = "vpc-0e6956f33ed20ddda"
  name     = "tg1"
  port     = 80
  protocol = "HTTP"

  health_check {
    path = "/"
  }
}


resource "aws_lb_listener" "tg1" {
  load_balancer_arn = aws_lb.lb1.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg1.arn
  }
}

resource "aws_lb_target_group_attachment" "tgw1" {
  target_group_arn = aws_lb_target_group.tg1.arn
    target_id = "${aws_instance.webserver1.id}"
  port = 80
}

resource "aws_lb_target_group_attachment" "tgw2" {
  target_group_arn = aws_lb_target_group.tg1.arn
  target_id = "${aws_instance.webserver2.id}"
  port = 80
}

