require "hario/behaviours/utils"

module Hario
  class PluckParser
    include ParserUtils

    attr_accessor :join_clause, :pluck_clause

    def initialize(pluck, klass)
      @pluck = pluck
      @klass = klass

      parse_pluck
    end

    private
      def parse_pluck
        @join_clause = {}
        @pluck_clause = [[@klass.table_name, 'id'].join('.')]

        ns, no_ns = @pluck.partition{ |p| p.include?('.') }

        no_ns.each{ |p| @pluck_clause << [@klass.table_name, p].join('.') }

        ns.each do |p|
          association_chain, attribute = parse_namespace(p)

          nested_associations = (association_chain.dup << {}).reverse.inject { |v, key| { key => v } }
          @join_clause.deep_merge!(nested_associations)

          attribute_table = table_name_from_association_chain(association_chain)
          @pluck_clause << [attribute_table, attribute].join('.')
        end
      end

      def parse_namespace(namespace)
        parts = namespace.split('.')
        attribute = parts.pop
        association_chain = parts

        [association_chain, attribute]
      end
  end
end