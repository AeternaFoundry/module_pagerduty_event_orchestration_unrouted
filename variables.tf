variable "event_orchestration_unrouteds" {
  description = <<EOT
Map of event_orchestration_unrouteds, attributes below
Required:
    - event_orchestration
    - catch_all (block):
        - actions (required, block):
            - event_action (optional)
            - extraction (optional, block):
                - regex (optional)
                - source (optional)
                - target (required)
                - template (optional)
            - severity (optional)
            - variable (optional, block):
                - name (required)
                - path (required)
                - type (required)
                - value (required)
    - set (block):
        - id (required)
        - rule (optional, block):
            - actions (required, block):
                - event_action (optional)
                - extraction (optional, block):
                    - regex (optional)
                    - source (optional)
                    - target (required)
                    - template (optional)
                - route_to (optional)
                - severity (optional)
                - variable (optional, block):
                    - name (required)
                    - path (required)
                    - type (required)
                    - value (required)
            - condition (optional, block):
                - expression (required)
            - disabled (optional)
            - label (optional)
EOT

  type = map(object({
    event_orchestration = string
    catch_all = object({
      actions = object({
        event_action = optional(string)
        extraction = optional(list(object({
          regex    = optional(string)
          source   = optional(string)
          target   = string
          template = optional(string)
        })))
        severity = optional(string)
        variable = optional(list(object({
          name  = string
          path  = string
          type  = string
          value = string
        })))
      })
    })
    set = list(object({
      id = string
      rule = optional(list(object({
        actions = object({
          event_action = optional(string)
          extraction = optional(list(object({
            regex    = optional(string)
            source   = optional(string)
            target   = string
            template = optional(string)
          })))
          route_to = optional(string)
          severity = optional(string)
          variable = optional(list(object({
            name  = string
            path  = string
            type  = string
            value = string
          })))
        })
        condition = optional(list(object({
          expression = string
        })))
        disabled = optional(bool)
        label    = optional(string)
      })))
    }))
  }))
  validation {
    condition = alltrue([
      for k, v in var.event_orchestration_unrouteds : (
        length(v.set) >= 1
      )
    ])
    error_message = "Each set list must contain at least 1 items"
  }
  # Note: 4 additional provider-side validators are enforced at apply time but not mirrored as validation{} blocks here (bespoke or non-mechanically-translatable).
}

