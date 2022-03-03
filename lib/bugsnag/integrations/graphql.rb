require "graphql"

module Bugsnag
  module GraphQL
    module Instrumentation
      class << self
        def before_query(query)
          # TODO: Should we simply save the query here, and lazy compute all of this instead?

          Bugsnag.configuration.set_request_data(:graphql, {
            # NOTE: Dumping in a bunch of stuff from https://graphql-ruby.org/api-doc/2.0.2/GraphQL/Query#operation_name-instance_method until we know what's useful
            schema: {
              name: query.schema.name,
              description: query.schema.description,
            },

            operation: {
              name: query.selected_operation_name,
              type: query.selected_operation&.operation_type, # Do we need &. here?
            },

            sanitized_query_string: query.sanitized_query_string,

            # Is there value in these?
            fingerprint: query.fingerprint,
            operation_fingerprint: query.operation_fingerprint,
            variables_fingerprint: query.variables_fingerprint,

            # ...
          })
        end

        def after_query(query)
          # TODO: The error is probably rescued and reported
          # from somewhere outside the query, so we probably
          # want to leave the report_data alone? TBD...
          # Then again, some reference apps clear context here...
        end
      end
    end
  end
end

GraphQL::Schema.instrument(:query, Bugsnag::GraphQL::Instrumentation)
GraphQL::Schema.instrument(:mutation, Bugsnag::GraphQL::Instrumentation)
GraphQL::Schema.instrument(:subscription, Bugsnag::GraphQL::Instrumentation)

Bugsnag.configuration.internal_middleware.use(Bugsnag::Middleware::GraphQL)
