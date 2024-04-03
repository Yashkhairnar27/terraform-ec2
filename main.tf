resource "aws_key_pair" "terra-key" {
  key_name = "terra-key"
  public_key = file("/home/hitman/Downloads/terra/key/terra-key.pub")
}

resource "aws_default_vpc" "default" {
}

resource "aws_security_group" "my_security_group" {
  name        = "my_security_group"
  vpc_id      = aws_default_vpc.default.id
}

resource "aws_security_group_rule" "ingress_rule" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.my_security_group.id
}

resource "aws_security_group_rule" "egress_rule" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.my_security_group.id
}

resource "aws_instance" "terraform_project" {
  ami           = var.ami_value
  instance_type = var.instance_type_value
  key_name      = aws_key_pair.terra-key.key_name
  vpc_security_group_ids = [aws_security_group.my_security_group.id]

  tags = {
    Name = "terraform-project"
  }
}