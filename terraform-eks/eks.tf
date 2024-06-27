module "eks" {
  source                    = "terraform-aws-modules/eks/aws"
  cluster_version           = var.eks_cluster_version
  cluster_name              = var.eks_cluster_name
  control_plane_subnet_ids  = aws_subnet.private.*.id
  subnet_ids                = aws_subnet.public.*.id
  vpc_id                    = aws_vpc.eks_vpc.id

  eks_managed_node_groups = {
    eks_nodes = {
      desired_capacity = var.desired_capacity
      max_capacity     = var.max_capacity
      min_capacity     = var.min_capacity
      instance_type = [var.node_instance_type]
    }
  }

  tags = {
    Name = var.eks_cluster_name
  }
}
