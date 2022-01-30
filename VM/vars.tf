#-----------------------
#User-Information
variable "Amount" {
    default = 0 #Amount
    type = number
}

variable "Environment" {
    default = "" #Environment
    type = string
}

variable "Users_Email" {
    type = list
    default = [] #Email
}

variable "Users_Name" {
    type = list
    default = [] #UserName
}

variable "Users_Id" {
    type = list
    default = [] #Id
}
#-----------------------



#-----------------------
#Terraform specific info
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
#-----------------------