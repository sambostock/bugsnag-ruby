require "graphql"

module Bugsnag
  module GraphQL
    module Instrumentation
      class << self
        def before_query(query)
          Bugsnag.configuration.set_request_data(:graphql, {
            # NOTE: Dumping in a bunch of stuff from https://graphql-ruby.org/api-doc/2.0.2/GraphQL/Query#operation_name-instance_method until we know what's useful
            operation_name: query.operation_name,
            schema: {
              name: query.schema.name,
              description: query.schema.description,
            },
            sanitized_query_string: query.sanitized_query_string,

            fingerprint: query.fingerprint,
            operation_fingerprint: query.operation_fingerprint,
            variables_fingerprint: query.variables_fingerprint,

            is_mutation: query.mutation?,
            is_query: query.query?,
            is_subscription: query.subscription?,
            is_valid: query.valid?,
            # ...
          })
        end

        def after_query(query)
          # TODO: The error is probably rescued and reported
          # from somewhere outside the query, so we probably
          # want to leave the report_data alone? TBD...
        end
      end
    end
  end
end

each_graphql_schema do |schema| # TODO: Figure out if this makes sense...
  schema.instrument(:query, Bugsnag::GraphQL::Instrumentation)
  schema.instrument(:mutation, Bugsnag::GraphQL::Instrumentation)
end

Bugsnag.configuration.internal_middleware.use(Bugsnag::Middleware::GraphQL)
