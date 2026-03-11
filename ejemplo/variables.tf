variable "ambiente" {
  description = "Ambiente de despliegue"
  type        = string
  validation {
    condition     = contains(["desarrollo", "staging", "produccion"], var.ambiente)
    error_message = "Ambiente debe ser desarrollo, staging o produccion"
  }
}
