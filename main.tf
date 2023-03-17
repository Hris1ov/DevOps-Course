provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3"{
    bucket = "devops1451"
    region = "us-east-1"
    dynamodb_table = "tf_state_lock"
    encrypt = true
    key = "test_key" 
  }
}

# EC2 instance resources
resource "aws_instance" "webserver1" {
  ami           = "ami-005f9685cb30f234b"
  instance_type = "t2.micro"
  subnet_id     = "subnet-085ecd58410dc966c"
  key_name      = "test_key"
  vpc_security_group_ids = ["sg-0fe370b9645d2f1bc"]

  user_data = <<-EOF
  #!/bin/bash
  sudo yum update -y
  sudo yum install httpd -y
  sudo systemctl start httpd
  sudo systemctl enable httpd
  sudo echo "web 1" >> /var/www/html/index.html
  EOF
}

resource "aws_instance" "webserver2" {
  ami           = "ami-005f9685cb30f234b"
  instance_type = "t2.micro"
  subnet_id     = "subnet-0bb21fd5313195e63"
  key_name      = "test_key"
  vpc_security_group_ids = ["sg-0fe370b9645d2f1bc"]

  user_data = <<-EOF
  #!/bin/bash
  sudo yum update -y
  sudo yum install httpd -y
  sudo systemctl start httpd
  sudo systemctl enable httpd
  sudo echo "web 2 modaf" >> /var/www/html/index.html
  EOF
}

resource "aws_lb" "lb1" {
  name               = "lb1"
  internal           = false
  load_balancer_type = "application"
  subnets = ["subnet-085ecd58410dc966c", "subnet-0bb21fd5313195e63"]

  security_groups = ["sg-0fe370b9645d2f1bc"]
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

