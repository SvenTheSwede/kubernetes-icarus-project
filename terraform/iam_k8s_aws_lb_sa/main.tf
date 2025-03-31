data "aws_iam_policy_document" "aws_lb_ctl" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-lb"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "aws_lb_ctl" {
  assume_role_policy = data.aws_iam_policy_document.aws_lb_ctl.json
  name               = "aws_lb_ctl"

  depends_on = [aws_iam_openid_connect_provider.eks]
}

resource "aws_iam_role_policy_attachment" "aws_lb_ctl" {
  role       = aws_iam_role.eks_pods.name
  count      = "${length(var.iam_policy_arn)}"
  policy_arn = "${var.iam_policy_arn[count.index]}"
  depends_on = [aws_iam_role.aws_lb_ctl]
}
