variable "chart_version" {
  description = "The version of the Ingress NGINX Controller Helm chart."
  type        = string
  default     = "4.5.2"
}

variable "prefix" {
  description = "Prefix uniquely identifies AWS resources. Needs to be unique per AWS (sub) account."
  type        = string
}
