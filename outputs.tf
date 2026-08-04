output "vpc_id" {
  value = module.network.vpc_id
}

#output "eks_cluster_name" {
# value = aws_eks_cluster.main.name
#}

#output "eks_endpoint" {
# value = aws_eks_cluster.main.endpoint
#}

#output "eks_nodegroup_name" {
# value = aws_eks_node_group.main.node_group_name
#}