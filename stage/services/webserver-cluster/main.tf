

provider "aws" {
  region = "us-east-1"

  # Allow any 2.x version of the AWS provider
  version = "~> 2.59.0"
}

module "webserver_cluster" {
  source = "../../../modules/services/webserver-cluster"

}

