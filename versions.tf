terraform {
  required_version = ">= 1.2.4"

  #experiments = [module_variable_optional_attrs]

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.22.0"
    }
  }
}
