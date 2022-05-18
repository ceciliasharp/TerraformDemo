variable "slot_count" {
  type = number
  #default = 0
  validation {
    condition = var.slot_count < 5 && var.slot_count >= 0
    error_message = "Slot count must be between 0 and 5."
  }
}