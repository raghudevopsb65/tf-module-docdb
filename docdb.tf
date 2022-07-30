resource "aws_docdb_cluster" "main" {
  cluster_identifier              = "${local.TAG_PREFIX}-docdb"
  engine                          = var.ENGINE
  engine_version                  = var.ENGINE_VERSION
  master_username                 = jsondecode(data.aws_secretsmanager_secret_version.secret.secret_string)["DOCDB_USER"]
  master_password                 = jsondecode(data.aws_secretsmanager_secret_version.secret.secret_string)["DOCDB_PASS"]
  vpc_security_group_ids          = [aws_security_group.main.id]
  db_subnet_group_name            = aws_docdb_subnet_group.main.name
  skip_final_snapshot             = true
  db_cluster_parameter_group_name = aws_docdb_cluster_parameter_group.main.name
}

resource "aws_docdb_cluster_instance" "main" {
  count              = var.NUMBER_OF_NODES
  identifier         = "${local.TAG_PREFIX}-docdb-instance"
  cluster_identifier = aws_docdb_cluster.main.id
  instance_class     = var.INSTANCE_CLASS
}

