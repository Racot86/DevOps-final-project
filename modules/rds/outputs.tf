# Універсальні output-и, щоб модуль був зручний незалежно від режиму

output "db_subnet_group_name" {
  description = "Name of the DB subnet group"
  value       = aws_db_subnet_group.this.name
}

output "security_group_id" {
  description = "ID of the security group attached to DB"
  value       = aws_security_group.this.id
}

output "endpoint" {
  description = "Primary endpoint"
  value = (
    var.use_aurora
    ? aws_rds_cluster.this[0].endpoint
    : aws_db_instance.this[0].address
  )
}


output "reader_endpoint" {
  description = "Reader endpoint (Aurora only)"
  value       = var.use_aurora ? aws_rds_cluster.this[0].reader_endpoint : null
}

output "port" {
  description = "Database port"
  value       = var.port
}
