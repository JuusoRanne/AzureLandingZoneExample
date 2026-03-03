variable "solution_name" {
  type = map(object({
    name    = string
    vnet    = bool
    peering = bool
    cidr    = string
    route   = bool
    githubOrg = string
  }))

  default = {
    solution1 = {
      name    = "solution1"
      vnet    = true
      peering = true
      cidr    = "/24"
      route   = true
      githubOrg = "defaultOrg"
    }
    solution2 = {
      name    = "solution2"
      vnet    = false
      peering = false
      cidr    = "/26"
      route   = false
      githubOrg = "defaultOrg"
    }
    }
  }
}
