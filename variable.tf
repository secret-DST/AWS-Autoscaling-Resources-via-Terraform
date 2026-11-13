variable "cidr_blocks" {
  description = "cidr blocks"
  type        = list(string)
  default     = ["10.0.0.0/16", "10.0.1.0/24", "10.0.2.0/24", "0.0.0.0/0"]
} ###        vpc cidr       subnet 2a      subnet 2b     all traffic

variable "http" {
  description = "http traffic values"
  type        = tuple([number, string])
  default     = [80, "tcp"]
}

variable "egress" {
  description = "http traffic values"
  type        = tuple([number, string])
  default     = [0, "-1"]
}

variable "ami" {
  description = "ubuntu ami"
  type        = string
  default     = "ami-0224ce6f9504665ee"
}

variable "instance_type" {
  description = "ubuntu ami"
  type        = string
  default     = "t2.micro"
}