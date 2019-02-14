Feature: Bugsnag raises errors in Rack

Background:
  Given I set environment variable "BUGSNAG_API_KEY" to "a35a2a72bd230ac0aa0f52715bbdc6aa"
  And I configure the bugsnag endpoint

Scenario Outline: An unhandled RuntimeError sends a report
  And I set environment variable "RUBY_VERSION" to "<ruby version>"
  And I start the service "rack<rack version>"
  And I wait for the app to respond on port "300<rack version>"
  When I navigate to the route "/unhandled" on port "300<rack version>"
  Then I should receive a request
  And the request used the "Ruby Bugsnag Notifier" notifier
  And the request used payload v4 headers
  And the request contained the api key "a35a2a72bd230ac0aa0f52715bbdc6aa"
  And the event "unhandled" is true
  And the event "severity" equals "error"
  And the event "severityReason.type" equals "unhandledExceptionMiddleware"
  And the event "severityReason.attributes.framework" equals "Rack"
  And the event "app.type" equals "rack"
  And the exception "errorClass" equals "RuntimeError"

  Examples:
  | ruby version | rack version |
  | 1.9.3        | 1            |
  | 2.0          | 1            |
  | 2.1          | 1            |
  | 2.2          | 1            |
  | 2.2          | 2            |
  | 2.3          | 1            |
  | 2.3          | 2            |
  | 2.4          | 1            |
  | 2.4          | 2            |
  | 2.5          | 1            |
  | 2.5          | 2            |

Scenario Outline: A handled RuntimeError sends a report
  And I set environment variable "RUBY_VERSION" to "<ruby version>"
  And I start the service "rack<rack version>"
  And I wait for the app to respond on port "300<rack version>"
  When I navigate to the route "/handled" on port "300<rack version>"
  Then I should receive a request
  And the request used the "Ruby Bugsnag Notifier" notifier
  And the request used payload v4 headers
  And the request contained the api key "a35a2a72bd230ac0aa0f52715bbdc6aa"
  And the event "unhandled" is false
  And the event "severity" equals "warning"
  And the event "severityReason.type" equals "handledException"
  And the event "app.type" equals "rack"
  And the exception "errorClass" equals "RuntimeError"

  Examples:
  | ruby version | rack version |
  | 1.9.3        | 1            |
  | 2.0          | 1            |
  | 2.1          | 1            |
  | 2.2          | 1            |
  | 2.2          | 2            |
  | 2.3          | 1            |
  | 2.3          | 2            |
  | 2.4          | 1            |
  | 2.4          | 2            |
  | 2.5          | 1            |
  | 2.5          | 2            |