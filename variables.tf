# tvcx-net - variables

variable "server" {
  type = object({
    private = object({
      address     = string
      endpoint    = string
      listen_port = number
      name        = string
    })
    air = object({
      address       = string
      endpoint      = string
      listen_port   = number
      name          = string
      lan_interface = string
    })
    guest = object({
      address     = string
      endpoint    = string
      listen_port = number
      name        = string
    })
  })
  description = "Server data."
}

variable "clients" {
  type = object({
    private = map(object({
      address              = string
      endpoint             = string
      persistent_keepalive = number
      listen_port          = number
    }))
    air = map(object({
      address              = string
      persistent_keepalive = number
    }))
    guest = map(object({
      address              = string
      persistent_keepalive = number
    }))
  })
  description = "Client data."
}
