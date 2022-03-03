module Bugsnag
  module Middleware
    ##
    # Attaches GraphQL query information to an error report
    class GraphQL
      def initialize(bugsnag)
        @bugsnag = bugsnag
      end

      def call(report)
        query = report.request_data[:graphql_query]
        report.add_tab(:graphql, tab_data_for(query)) if query

        @bugsnag.call(report)
      end

      private

      def tab_data_for(query)
        {
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
          fingerprints: {
            query: query.fingerprint,
            operation: query.operation_fingerprint,
            variables: query.variables_fingerprint,
          }

          # ...
        }
      end
    end
  end
end
