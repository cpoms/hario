require "hario/version"
require "hario/behaviours/filter"
require "hario/behaviours/pluck"

module Hario
  module Filterable
    extend ActiveSupport::Concern

    module ClassMethods
      def search(filters, pluck = nil)
        s = all
        s = s.apply_filters(filters) if filters
        s = s.apply_pluck(pluck) if pluck
        s
      end

      def apply_filters(filters)
        fp = FilterParser.new(filters, self)

        fp.where_clauses.reduce(joins(fp.join_clause), &:where)
      end

      def apply_pluck(pluck)
        pp = PluckParser.new(pluck, self)

        results = hash_pluck(*pp.pluck_clause)

        remove_local_table_prefix(results)
      end

      def remove_local_table_prefix(results)
        results.map{ |r| r.transform_keys!{ |k| k.gsub(/^#{table_name}\./, '') } }
      end
    end
  end
end
