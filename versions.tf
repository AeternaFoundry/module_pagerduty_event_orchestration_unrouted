terraform {
  required_version = ">= 1.6.0"
  required_providers {
    pagerduty = {
      source  = "PagerDuty/pagerduty"
      version = "~> 3.36.0"
    }
  }
}
