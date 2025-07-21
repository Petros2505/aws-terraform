resource "aws_vpc" "main" {
  cidr_block = var.vpc_cdr
  tags = merge(var.tags, {
    Name = var.vpc_name
  })
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_public_cidr
  availability_zone       = var.subnet_public_availability_zone[0]
  map_public_ip_on_launch = true
  tags = merge(var.tags, {
    Name = var.public_subnet_name
  })
}

resource "aws_subnet" "private" {
  for_each          = var.private_subnet_cidr
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr_block
  availability_zone = var.private_subnet_availability_zone[tonumber(each.key) - 1]
  tags = merge(var.tags, {
    Name = "${var.private_subnet_name}-${each.key}"
  })
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = merge(var.tags, {
    Name = var.internet_gateway
  })
}

resource "aws_eip" "nat_ip" {
  tags = merge(var.tags, {
    Name = var.nat-ip
  })
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat_ip.id
  subnet_id     = aws_subnet.public.id

  tags = merge(var.tags, {
    Name = var.nat_gateway
  })

  depends_on = [aws_internet_gateway.main]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(var.tags, {
    Name = var.public_route_table
  })
}
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main.id
  }

  tags = merge(var.tags, {
    Name = var.private-route-table
  })
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  for_each       = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}


