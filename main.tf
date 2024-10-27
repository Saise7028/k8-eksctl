resource "aws_instance" "workstation" {
  ami                    = "ami-09c813fb71547fc4f"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["vpc-0b8195d98ce48090a"]
  tags = {
    Name = "workstation"
  }

}

resource "aws_security_group" "allow_all_workstation" {
  name        = "Allow_All"
  description = "Allow port number 22 for ssh Access"

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]

  }

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]

  }

  tags = {
    Name = "workstation"
  }



}