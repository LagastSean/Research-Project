#variable "Amount" {
#    description = "Hoeveel webservers wil je deployen?"
#    type = number
#}

variable "Amount" {
    default = 2 #Amount
    type = number
}

variable "Users_Email" {
    type = list
    default = ["mathias.de.herdt@student.howest.be","simon.demuynck2@student.howest.be"] #Email
}

variable "Users_Name" {
    type = list
    default = ["Mathias","Simon"] #UserName
}

variable "Display_Name" {
    type = list
    default = ["Demuynck Simon","De Herdt Mathias"]
}

variable "Users_Id" {
    type = list
    default = ["fc100f9e-808d-4d1a-bd56-739a3a359c05","db6e109d-cb38-4951-9c0a-2653d3619b4e"] #Id
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
