require "graphql"

module Bugsnag
  module GraphQL
    module Instrumentation
      class << self
        def before_query(query)
          Bugsnag.configuration.set_request_data(:graphql_query, query)
        end

        def after_query(query)
          # TODO: The error is probably rescued and reported
          # from somewhere outside the query, so we probably
          # want to leave the report_data alone? TBD...
          # Then again, some reference apps clear context here...

          # Bugsnag.configuration.unset_request_data(:graphql_query, query)
        end
      end
    end
  end
end

GraphQL::Schema.instrument(:query, Bugsnag::GraphQL::Instrumentation)
GraphQL::Schema.instrument(:mutation, Bugsnag::GraphQL::Instrumentation)
GraphQL::Schema.instrument(:subscription, Bugsnag::GraphQL::Instrumentation)

Bugsnag.configuration.internal_middleware.use(Bugsnag::Middleware::GraphQL)
