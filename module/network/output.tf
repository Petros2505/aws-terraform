output "private_subnet_id" {
  value = [for subnet in aws_subnet.private : subnet.id]
}
output "public_subnet_id" {
  value = aws_subnet.public.id
}
output "vpc_id" {
  value = aws_vpc.main.id
}