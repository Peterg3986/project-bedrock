resource "aws_iam_user" "dev_view" {
  name = "bedrock-dev-view"
  tags = {
    Project = local.project_tag
  }
}

resource "aws_iam_user_policy_attachment" "dev_view_readonly" {
  user       = aws_iam_user.dev_view.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

resource "aws_iam_access_key" "dev_view_key" {
  user = aws_iam_user.dev_view.name
}
