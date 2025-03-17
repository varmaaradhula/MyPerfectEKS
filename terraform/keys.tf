resource "aws_key_pair" "jump_server_key" {
  key_name   = "jump-key"  # Give it a name in AWS
  public_key = file("./Server-Keys/jump-key.pub")  # Path to your public key
}