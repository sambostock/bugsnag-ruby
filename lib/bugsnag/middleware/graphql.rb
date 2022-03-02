module Bugsnag
  module Middleware
    ##
    # Attaches GraphQL query information to an error report
    class GraphQL
      def initializer(bugsnag)
        @bugsnag = bugsnag
      end

      def call(report)
        graphql = report.request_data[:graphql]
        if graphql
          report.add_tab(:graphql, graphql)
          # TODO: Should we be setting automatic_context?
        end

        @bugsnag.call(report)
      end
    end
  end
end
