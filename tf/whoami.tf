data "aws_caller_identity" "current" {}

# The calling user needs iam:GetRole.
data "aws_iam_session_context" "this" {
  count = 0
  arn   = data.aws_caller_identity.current.arn
}