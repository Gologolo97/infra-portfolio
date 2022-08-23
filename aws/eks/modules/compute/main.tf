resource "aws_iam_role" "eks_cluster" {
  name = "${var.user_name}-eks_iam_role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "amazon_eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
}

resource "aws_eks_cluster" "eks" {
  name     = var.user_name
  role_arn = aws_iam_role.eks_cluster.arn

  version = "1.23"

  vpc_config {
    subnet_ids = [
      var.subnet_public[0].id,
      var.subnet_public[1].id,
      var.subnet_private[0].id,
      var.subnet_private[1].id
    ]
  }

  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_cluster_policy
  ]
}

resource "aws_iam_role" "nodes_general" {
  name = "${var.user_name}-eks-node-group-general"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "amazon_EKS_Worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.nodes_general.name
}

resource "aws_iam_role_policy_attachment" "amazon_EKS_CNI_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.nodes_general.name
}

resource "aws_iam_role_policy_attachment" "amazon_EC2_ContainerRegistry_ReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.nodes_general.name
}

resource "aws_eks_node_group" "private_nodes" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "nodes-general"
  node_role_arn   = aws_iam_role.nodes_general.arn

  subnet_ids = [
    var.subnet_private[0].id,
    var.subnet_private[1].id
  ]

  capacity_type  = "ON_DEMAND"
  instance_types = ["t2.large"]

  scaling_config {
    desired_size = 3
    max_size     = 3
    min_size     = 0
  }

  update_config {
    max_unavailable = 1
  }

  labels = {
    role = "nodes-general"
  }

  version = "1.23"

  depends_on = [
    aws_iam_role_policy_attachment.amazon_EKS_Worker_node_policy,
    aws_iam_role_policy_attachment.amazon_EKS_CNI_policy,
    aws_iam_role_policy_attachment.amazon_EC2_ContainerRegistry_ReadOnly,
  ]
}

