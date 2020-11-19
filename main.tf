# tvcx-net

terraform {
  backend "local" {
    path = "./terraform.tfstate"
  }

  required_version = ">= 0.13"
}

locals {
  server_private = merge(var.server.private, {
    public_key = file("${path.module}/keys/private_${var.server.private.name}.pub")
  })

  server_air = merge(var.server.air, {
    public_key = file("${path.module}/keys/air_${var.server.air.name}.pub")
  })

  server_guest = merge(var.server.guest, {
    public_key = file("${path.module}/keys/guest_${var.server.guest.name}.pub")
  })

  clients_private = {for client_key, client_value in var.clients.private: client_key => merge(client_value, {
    name       = client_key
    public_key = file("${path.module}/keys/private_${client_key}.pub")
  })}

  clients_air = {for client_key, client_value in var.clients.air: client_key => merge(client_value, {
    name       = client_key
    public_key = file("${path.module}/keys/air_${client_key}.pub")
  })}

  clients_guest = {for client_key, client_value in var.clients.guest: client_key => merge(client_value, {
    name       = client_key
    public_key = file("${path.module}/keys/guest_${client_key}.pub")
  })}
}

resource "local_file" "server_private" {
  content = templatefile("./tvcxvpn/server_private.conf", {
    server  = local.server_private
    clients = local.clients_private
  })
  filename = "${path.module}/out/wg_private_${local.server_private.name}.conf"
}

resource "local_file" "server_air" {
  content = templatefile("./tvcxvpn/server_air.conf", {
    server  = local.server_air
    clients = local.clients_air
  })
  filename = "${path.module}/out/wg_air_${local.server_air.name}.conf"
}

resource "local_file" "server_guest" {
  content = templatefile("./tvcxvpn/server_guest.conf", {
    server  = local.server_guest
    clients = local.clients_guest
  })
  filename = "${path.module}/out/wg_guest_${local.server_guest.name}.conf"
}

resource "local_file" "client_private" {
  for_each = local.clients_private

  content = templatefile("./tvcxvpn/client_private.conf", {
    server = local.server_private
    client = each.value
  })
  filename = "${path.module}/out/wg_private_${each.value.name}.conf"
}

resource "local_file" "client_air" {
  for_each = local.clients_air

  content = templatefile("./tvcxvpn/client_air.conf", {
    server = local.server_air
    client = each.value
  })
  filename = "${path.module}/out/wg_air_${each.value.name}.conf"
}

resource "local_file" "client_guest" {
  for_each = local.clients_guest

  content = templatefile("./tvcxvpn/client_guest.conf", {
    server = local.server_guest
    client = each.value
  })
  filename = "${path.module}/out/wg_guest_${each.value.name}.conf"
}
