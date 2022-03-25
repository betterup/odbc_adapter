require 'odbc_adapter/snowflake/schema_statements'

module ODBCAdapter
  module Adapters
    # An adapter for use with Snowflake via ODBC
    class SnowflakeODBCAdapter < ActiveRecord::ConnectionAdapters::ODBCAdapter
      include ODBCAdapter::Snowflake::SchemaStatements

      class BindSubstitution < Arel::Visitors::ToSql
        include Arel::Visitors::BindVisitor
      end

      # Snowflake is fairly similar to PG
      def arel_visitor
        Arel::Visitors::PostgreSQL.new(self)
      end
    end
  end
end
