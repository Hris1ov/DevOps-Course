provider "aws" {
region = "us-east-1"

}

terraform {
  backend "s3"{
    bucket         = "devops3-terraform-state"
    key            = "terraform.tfstate"
    region 	   = "us-east-1"
    dynamodb_table = "tf_state_lock"
    encrypt        = true
 }
}

# EC2 instance resources
resource "aws_instance" "webserver1" {
  ami           	 = "ami-005f9685cb30f234b"
  instance_type 	 = "t2.micro"
  subnet_id     	 = "subnet-0bb21fd5313195e63"
  key_name      	 = "key"
  vpc_security_group_ids = ["sg-0593514038c77cc43"]

  user_data = <<-EOF
  #!/bin/bash
  sudo yum update -y
  sudo yum install httpd -y
  sudo systemctl start httpd
  sudo systemctl enable httpd
  sudo echo "try to fix the problem I created..." >> /var/www/html/index.html
  EOF
}

resource "aws_instance" "webserver2" {
  ami                    = "ami-005f9685cb30f234b"
  instance_type          = "t2.micro"
  subnet_id              = "subnet-07a6fa2d7b23c1d7d"
  key_name               = "key"
  vpc_security_group_ids = ["sg-0593514038c77cc43"]

  user_data = <<-EOF
  #!/bin/bash
  sudo yum update -y
  sudo yum install httpd -y
  sudo systemctl start httpd
  sudo systemctl enable httpd
  sudo echo "...when I tried to fix the problem I created when I..." >> /var/www/html/index.html
  EOF
}

resource "aws_lb" "lb1" {
  name               = "lb1"
  internal           = false
  load_balancer_type = "application"
  subnets            = ["subnet-0bb21fd5313195e63", "subnet-07a6fa2d7b23c1d7d"]
  security_groups    = ["sg-0593514038c77cc43"]
}

resource "aws_lb_target_group" "tg1" {
  vpc_id   = "vpc-0e6956f33ed20ddda"
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
  target_id        = "${aws_instance.webserver1.id}"
  port             = 80
}

resource "aws_lb_target_group_attachment" "tgw2" {
  target_group_arn = aws_lb_target_group.tg1.arn
  target_id        = "${aws_instance.webserver2.id}"
  port             = 80
}
