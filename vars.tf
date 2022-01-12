variable "Amount" {
    description = "Hoeveel webservers wil je deployen?"
    type = number
}

variable "RG_Name" {
    type = list
    default = ["SeanLagast_Terraform","JoeMama_Terraform"]
}

variable "User_Name" {
    type = list
    default = ["SeanLagast","JoeMama"]
}

variable "RG_Location" {
    default = "westeurope"
}

variable "SP_Name" {
    default = "WebAppServicePlan"
}

variable "SP_tier" {
    default = "Free"
}

variable "SP_size" {
    default = "F1"
}

variable "AS_bootstrap" {
    default = "https://github.com/Azure-Samples/nodejs-docs-hello-world"
}

variable "AS_bootstrap_branch" {
    default = "master"
}