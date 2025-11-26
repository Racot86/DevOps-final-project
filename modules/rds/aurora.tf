# Aurora Cluster
resource "aws_rds_cluster" "this" {
  count = var.use_aurora ? 1 : 0

  cluster_identifier = "${var.name}-cluster"

  engine         = var.engine           
  engine_version = var.engine_version

  database_name   = var.db_name
  master_username = var.username
  master_password = var.password
  port            = var.port

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.this.id]

  backup_retention_period = var.backup_retention_period
  preferred_backup_window = "03:00-04:00"

  storage_encrypted   = true
  apply_immediately   = true
  deletion_protection = false
  skip_final_snapshot = true

  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.this[0].name

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-cluster"
      Type = "aurora-cluster"
    }
  )
}

# Writer instance
resource "aws_rds_cluster_instance" "this" {
  count = var.use_aurora ? var.aurora_instance_count : 0

  identifier         = "${var.name}-instance-${count.index}"
  cluster_identifier = aws_rds_cluster.this[0].id

  engine         = var.engine
  engine_version = var.engine_version
  instance_class = var.instance_class

  db_subnet_group_name   = aws_db_subnet_group.this.name
  publicly_accessible    = false
  apply_immediately      = true

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-instance-${count.index}"
      Type = "aurora-instance"
      Role = count.index == 0 ? "writer" : "reader"
    }
  )

  depends_on = [aws_rds_cluster.this]
}
