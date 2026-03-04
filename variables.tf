variable "solution_name" {
  type = map(object({
    name         = string
    environments = list(string)
    vnet         = bool
    peering      = bool
    cidr         = string
    route        = bool
    githubOrg    = string
  }))

  default = {
    solution1 = {
      name         = "solution1"
      environments = ["dev", "test", "prod"]
      vnet         = true
      peering      = true
      cidr         = "/24"
      route        = true
      githubOrg    = "defaultOrg"
    }
    solution2 = {
      name         = "solution2"
      environments = ["dev", "test", "prod"]
      vnet         = false
      peering      = false
      cidr         = "/26"
      route        = false
      githubOrg    = "defaultOrg"
    }
    }
  }
}
