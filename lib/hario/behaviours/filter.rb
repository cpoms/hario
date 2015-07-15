require "hario/behaviours/utils"

class FilterParser
  include ParserUtils

  OPERATORS = { lt: '<', gt: '>', lte: '<=', gte: '>=', like: 'like', equals: '=' }

  attr_accessor :join_clause, :where_clauses

  def initialize(filters, klass)
    @filters = filters
    @klass = klass

    parse_filters
  end

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
        attribute_table = table_name_from_association_chain(association_chain)
      end

      case operator
      when :equals
        condition = { attribute => value }
        condition = { attribute_table => condition } if attribute_table
      else
        value = "%#{value}%" if operator == :like
        operator = OPERATORS[operator]
        condition = ["? #{operator} ?", attribute, value]
        condition[1].prepend("#{attribute_table}.") if attribute_table
      end

      condition
    end
end