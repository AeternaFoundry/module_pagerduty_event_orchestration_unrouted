resource "pagerduty_event_orchestration_unrouted" "event_orchestration_unrouteds" {
  for_each = var.event_orchestration_unrouteds

  event_orchestration = each.value.event_orchestration

  catch_all {
    actions {
      event_action = each.value.catch_all.actions.event_action
      dynamic "extraction" {
        for_each = each.value.catch_all.actions.extraction != null ? each.value.catch_all.actions.extraction : []
        content {
          regex    = extraction.value.regex
          source   = extraction.value.source
          target   = extraction.value.target
          template = extraction.value.template
        }
      }
      severity = each.value.catch_all.actions.severity
      dynamic "variable" {
        for_each = each.value.catch_all.actions.variable != null ? each.value.catch_all.actions.variable : []
        content {
          name  = variable.value.name
          path  = variable.value.path
          type  = variable.value.type
          value = variable.value.value
        }
      }
    }
  }

  dynamic "set" {
    for_each = each.value.set
    content {
      id = set.value.id
      dynamic "rule" {
        for_each = set.value.rule != null ? set.value.rule : []
        content {
          actions {
            event_action = rule.value.actions.event_action
            dynamic "extraction" {
              for_each = rule.value.actions.extraction != null ? rule.value.actions.extraction : []
              content {
                regex    = extraction.value.regex
                source   = extraction.value.source
                target   = extraction.value.target
                template = extraction.value.template
              }
            }
            route_to = rule.value.actions.route_to
            severity = rule.value.actions.severity
            dynamic "variable" {
              for_each = rule.value.actions.variable != null ? rule.value.actions.variable : []
              content {
                name  = variable.value.name
                path  = variable.value.path
                type  = variable.value.type
                value = variable.value.value
              }
            }
          }
          dynamic "condition" {
            for_each = rule.value.condition != null ? rule.value.condition : []
            content {
              expression = condition.value.expression
            }
          }
          disabled = rule.value.disabled
          label    = rule.value.label
        }
      }
    }
  }
}

