resource "aws_db_instance" "this" {
  count = var.use_aurora ? 0 : 1

  identifier = var.name

  engine         = var.engine
  engine_version = var.engine_version
  instance_class = var.instance_class

  db_name  = var.db_name
  username = var.username
  password = var.password
  port     = var.port

  allocated_storage    = var.allocated_storage
  multi_az             = var.multi_az
  storage_encrypted    = true
  skip_final_snapshot  = true
  deletion_protection  = false
  apply_immediately    = true
  publicly_accessible  = false

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.this.id]

  parameter_group_name = aws_db_parameter_group.this[0].name

  tags = merge(
    var.tags,
    {
      Name = var.name
      Type = "rds-instance"
    }
  )
}
