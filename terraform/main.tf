provider "aws" {
  region = var.region
}

data "aws_ssm_parameter" "ami" {
  name = "/golden-ami/dev/latest"
}

resource "aws_security_group" "ec2_sg" {
  name   = "golden-ami-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ec2" {
  ami                    = data.aws_ssm_parameter.ami.value
  instance_type           = "t3.micro"
  subnet_id               = var.subnet_id
  vpc_security_group_ids  = [aws_security_group.ec2_sg.id]
  iam_instance_profile    = var.instance_profile

  tags = {
    Name = "golden-ami-ec2"
  }
}
