data "aws_organizations_organization" "org" {}

data "aws_organizations_account" "new_account" {
  for_each = { for account in data.aws_organizations_organization.org.accounts : account.email => account }
  id       = each.value.id
}

resource "aws_iam_role" "admin_role" {
  name = "AdministratorAccessRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_organizations_account.new_account["pocexample@email.com"].id}:root"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "admin_attach" {
  name       = "AdminPolicyAttachment"
  roles      = [aws_iam_role.admin_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
