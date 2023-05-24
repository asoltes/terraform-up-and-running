provider "aws" {
  region = "ap-southeast-1"

}
### count

# resource "aws_iam_user" "iam-example" {
#   count = 3
#   name  = "andres.${count.index}"

# }

variable "user_names" {
  description = "Create IAM users with these names"
  type        = list(string)
  default     = ["neo", "trinity", "andrew"]
}

resource "aws_iam_user" "iam_usernames" {
  count = length(var.user_names)
  name  = var.user_names[count.index]
}



### for_each

resource "aws_iam_user" "example" {
    for_each = toset(var.user_names)
    name  = each.value
  
}
