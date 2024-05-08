variable "cidr" {
  default = "10.0.0.0/16"
  
}

variable "tags" {
    default = {
        project = "Expense"
        Environment = "Dev"
        Module = "DB"
        Name = "DB"      
        
    }
  
}