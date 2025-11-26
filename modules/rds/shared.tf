# Subnet group (used by both)
resource "aws_db_subnet_group" "this" {
  name       = "${var.name}-subnet-group"
  subnet_ids = var.subnet_ids

  description = "DB subnet group for ${var.name}"

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-subnet-group"
    }
  )
}

# Security group (used by both)
resource "aws_security_group" "this" {
  name        = "${var.name}-sg"
  description = "Security group for ${var.name} database"
  vpc_id      = var.vpc_id


  dynamic "ingress" {
    for_each = var.allowed_cidr_blocks
    content {
      from_port   = var.port
      to_port     = var.port
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
      description = "DB access from ${ingress.value}"
    }
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-sg"
    }
  )
}

# Parameter Group for RDS instance
resource "aws_db_parameter_group" "this" {
  count = var.use_aurora ? 0 : 1

  name   = "${var.name}-param-group"
  family = var.parameter_group_family

  description = "Parameter group for ${var.name} RDS instance"


parameter {
  name         = "max_connections"
  value        = "200"
  apply_method = "pending-reboot"
}

  parameter {
    name  = "log_statement"
    value = "none"
  }

  parameter {
    name  = "work_mem"
    value = "4096"
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-param-group"
    }
  )
}

# Cluster Parameter Group for Aurora
resource "aws_rds_cluster_parameter_group" "this" {
  count = var.use_aurora ? 1 : 0

  name   = "${var.name}-cluster-param-group"
  family = var.parameter_group_family

  description = "Cluster parameter group for ${var.name} Aurora cluster"

  parameter {
    name         = "max_connections"
    value        = "200"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "log_statement"
    value        = "none"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "work_mem"
    value        = "4096"
    apply_method = "pending-reboot"
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-cluster-param-group"
    }
  )
}
