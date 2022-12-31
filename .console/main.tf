
variable "enabled" {
    type = map(any)
    default = {
        "resource_group" = true
    }
}

output "x" {
    value = {
     lookup(var.enabled, "resource_group1", false) ? "resource_group1" : {} : null,
    }
}