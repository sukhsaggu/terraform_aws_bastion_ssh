# Upload the keypair

resource "aws_key_pair" "mykeypair" {
  key_name   = "mykeypair"
  public_key = file(var.ssh_public_key_path)
}

# Bastion instance

resource "aws_instance" "my_bastion_instance" {
  ami                         = "ami-0a70476e631caa6d3"
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.mykeypair.key_name
  vpc_security_group_ids      = [aws_security_group.allow_ssh.id]
  subnet_id                   = aws_subnet.public.id
  associate_public_ip_address = true

  tags = {
    Name = "My Bastion Instance"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y"
    ]
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file(var.ssh_private_key_path)
    host        = self.public_ip
  }

}

# Private Instance

resource "aws_instance" "my_private_instance" {
  ami                         = "ami-0a70476e631caa6d3"
  instance_type               = "t2.small"
  key_name                    = aws_key_pair.mykeypair.key_name
  vpc_security_group_ids      = [aws_security_group.allow_ssh.id]
  subnet_id                   = aws_subnet.private.id
  associate_public_ip_address = false

  tags = {
    Name = "My Private Instance"
  }
  
  # Install a LAMP web Server as per
  # https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-lamp-amazon-linux-2.html#prepare-lamp-server
  
  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2",
      "cat /etc/system-release",
      "sudo yum install -y httpd mariadb-server",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd",
      "sudo systemctl is-enabled httpd"
    ]
  }

  connection {
    host             = self.private_ip
    type             = "ssh"
    user             = "ec2-user"
    private_key      = file(var.ssh_private_key_path)
    bastion_host     = aws_instance.my_bastion_instance.public_ip
    bastion_host_key = file(var.ssh_public_key_path)
  }
}