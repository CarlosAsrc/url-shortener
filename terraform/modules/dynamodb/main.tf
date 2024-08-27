resource "aws_dynamodb_table" "url_table" {
  name           = "url-development"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "shortUrl"

  global_secondary_index {
    name               = "LongUrlIndex"
    hash_key           = "longUrl"
    projection_type    = "ALL"

    read_capacity  = 10
    write_capacity = 10
  }

    global_secondary_index {
    name               = "CreatedAtIndex"
    hash_key           = "createdAt"
    projection_type    = "ALL"

    read_capacity  = 5
    write_capacity = 5
  }

  global_secondary_index {
    name               = "AccessCountIndex"
    hash_key           = "accessCount"
    projection_type    = "ALL"

    read_capacity  = 5
    write_capacity = 5
  }

  attribute {
    name = "shortUrl"
    type = "S"
  }

  attribute {
    name = "longUrl"
    type = "S"
  }

  attribute {
    name = "createdAt"
    type = "S"
  }

  attribute {
    name = "accessCount"
    type = "N"
  }
}
