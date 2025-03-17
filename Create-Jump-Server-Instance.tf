resource "aws_instance" "jump_server_instance" {
  ami           = lookup(var.AMIS, var.AWS_REGION)  # Replace with a valid AMI ID for your region
  instance_type = "t2.micro"  # Adjust instance type as needed
  subnet_id     = module.vpc.public_subnets[0]  # Place instances in private subnet
  key_name      = aws_key_pair.jump_server_key.key_name
  vpc_security_group_ids = [aws_security_group.jump-server-sg.id]  # Attach the newly created security group
  associate_public_ip_address = true 
  
  tags = {
    Name = "Jump Server Instance"
  }
}