require "hario/behaviours/utils"

module Hario
  class FilterParser
    include ParserUtils

    OPERATORS = { lt: '<', gt: '>', lte: '<=', gte: '>=', like: 'like', equals: '=', is: 'is', in: 'in' }
    IS_VALUES = { null: 'NULL', not_null: 'NOT NULL' }

    attr_accessor :join_clause, :where_clauses

    def initialize(filters, klass)
      @filters = filters
      @klass = klass

      parse_filters
    end

    InvalidValueError     = Class.new(RuntimeError)

    private
      def parse_filters
        @join_clause, @where_clauses = @filters.inject([{}, []]) do |m, (descriptor, value)|
          association_chain, attribute, operator = parse_descriptor(descriptor)
          condition = build_condition(association_chain, attribute, operator, value)

          nested_associations = (association_chain.dup << {}).reverse.inject { |v, key| { key => v } }
          joins = m[0].deep_merge(nested_associations)
          wheres = m[1] + [condition]
          [joins, wheres]
        end
      end

      def parse_descriptor(descriptor)
        parts = descriptor.split('.')
        operator = parts.pop.to_sym
        attribute = parts.pop
        association_chain = parts

        [association_chain, attribute, operator]
      end

      def build_condition(association_chain, attribute, operator, value)
        if association_chain.any?
          end_model = end_model_from_association_chain(association_chain)
          attribute_table = end_model.table_name
        else
          end_model = @klass
        end

        raise_if_unlisted_attribute!(:filters, end_model, attribute)
        raise_if_invalid_attribute!(attribute, end_model)

        case operator
        when :equals
          condition = { attribute => value }
          condition = { attribute_table => condition } if attribute_table
        when :in
          value = value.split(',').map(&:strip) if value.is_a?(String)
          condition = { attribute => value }
          condition = { attribute_table => condition } if attribute_table
        when :is
          value = value.to_sym
          raise_if_invalid_is_value!(value)
          condition = ["#{attribute} #{operator} #{IS_VALUES[value]}"]
          condition[0].prepend("#{attribute_table || @klass.table_name}.")
        else
          operator = OPERATORS[operator]
          condition = ["#{attribute} #{operator} ?", value]
          condition[0].prepend("#{attribute_table || @klass.table_name}.")
        end

        condition
      end

      def raise_if_invalid_is_value!(value)
        unless IS_VALUES[value]
          raise InvalidValueError,
            "When using 'is', value must be one of #{IS_VALUES.keys.join(', ')}"
        end
      end

      def raise_if_invalid_attribute!(attribute, end_model)
        unless end_model.column_names.include?(attribute)
          raise InvalidAttributeError,
            "'#{attribute}' is not a valid column name for '#{end_model.table_name}'"
        end
      end
  end
end