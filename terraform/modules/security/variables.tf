variable "project" {
  description = "Project name used for naming resources"
  type        = string
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}