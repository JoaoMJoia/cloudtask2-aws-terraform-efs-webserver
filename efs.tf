resource "aws_efs_file_system" "EFS" {
  creation_token = "my-product"

  tags = {
    Name = "MyEFS"
  }
}

resource "aws_efs_mount_target" "alpha" {
  file_system_id = aws_efs_file_system.EFS.id
  subnet_id      = aws_instance.instance.subnet_id
}