resource "aws_default_vpc" "default" {
  tags = {
    Name = "demo VPC"
  }
}