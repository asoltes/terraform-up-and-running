data "terraform_remote_state" "db" {
  backend = "s3"

  config = {
    bucket = "terraform-up-and-running-state-andres"
    key    = "stage/data-stores/mysql/terraform.tfstate"
    region = "ap-southeast-1"
  }
}