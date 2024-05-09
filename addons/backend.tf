terraform {
  backend "local" {}
}

data "terraform_remote_state" "cluster" {
  backend = "local"

  config = {
    path = "../terraform.tfstate"
  }
}
