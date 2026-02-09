resource "aws_security_group" "web" {
  name        = "web_sg_v1"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
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

resource "aws_key_pair" "this" {
  key_name   = "devops-new"
  public_key = file("~/.ssh/devops-new.pub")
}

resource "aws_instance" "web" {
  ami           = "ami-0c398cb65a93047f2" # Ubuntu 22.04
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.web.id]
  key_name      = aws_key_pair.this.key_name # create keypair in AWS
  associate_public_ip_address = true

  tags = {
    Name = "DevOpsWebServer"
  }
}

