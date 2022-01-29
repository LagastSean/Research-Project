#-----------------------
#User-Information
variable "Amount" {
    default = 5 #Amount
    type = number
}

variable "Environment" {
    default = "Web" #Environment
    type = string
}

variable "Users_Email" {
    type = list
    default = ["mathias.de.herdt@student.howest.be","simon.demuynck2@student.howest.be","sean.lagast@student.howest.be","ward.vandale@student.howest.be","miro.verleysen@student.howest.be"] #Email
}

variable "Users_Name" {
    type = list
    default = ["Mathias","Simon","Sean","Ward","Miro"] #UserName
}

variable "Users_Id" {
    type = list
    default = ["fc100f9e-808d-4d1a-bd56-739a3a359c05","db6e109d-cb38-4951-9c0a-2653d3619b4e","7f5bbb6d-b17b-4812-a8fa-a05bd7755bda","7f424a22-ccaa-49ed-9082-06e404263172","2ccfb3e7-9170-40bf-9bdb-331f7db1a2ab"] #Id
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