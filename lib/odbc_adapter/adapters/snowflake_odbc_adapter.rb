require 'odbc_adapter/snowflake/schema_statements'

module ODBCAdapter
  module Adapters
    # An adapter for use with Snowflake via ODBC
    class SnowflakeODBCAdapter < ActiveRecord::ConnectionAdapters::ODBCAdapter
      include ODBCAdapter::Snowflake::SchemaStatements

      # Copy the null adapter because prepared statements aren't behaving for now
      def prepared_statements
        false
      end

      # Quoting needs to be changed for snowflake
      def quote_column_name(name)
        name.to_s
      end

      # Snowflake is fairly similar to PG
      def arel_visitor
        Arel::Visitors::PostgreSQL.new(self)
      end

      private

      # Override dbms_type_cast to get the values encoded in UTF-8
      def dbms_type_cast(_columns, values)
        values.each { |row| row.each_index { |idx| row[idx] = row[idx].force_encoding('UTF-8') if row[idx].is_a?(String) } }
      end
    end
  end
end
