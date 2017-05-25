require "hario/version"
require "hario/behaviours/filter"
require "hario/behaviours/pluck"

module Hario
  module Filterable
    HARIO_APPLY_TYPES = %w( filters pluck ).map(&:to_sym)

    attr_reader :hario_attributes_list

    def search(filters, pluck = [])
      pluck ||= []
      pluck = pluck.reject{ |p| p.nil? || p.empty? }

      s = all
      s = s.apply_filters(filters) if filters
      s = s.apply_pluck(pluck) if pluck.any?
      s
    end

    def apply_filters(filters)
      fp = FilterParser.new(filters, self)

      fp.where_clauses.reduce(joins(fp.join_clause), &:where)
    end

    def apply_pluck(pluck)
      pp = PluckParser.new(pluck, self)

      results = joins(pp.join_clause).hash_pluck(*pp.pluck_clause)

      remove_local_table_prefix(results)
    end

    def remove_local_table_prefix(results)
      results.map{ |r| r.transform_keys!{ |k| k.gsub(/^#{table_name}\./, '') } }
    end

    def hash_pluck(*keys)
      pluck(*keys).map{ |vals| Hash[keys.zip(Array(vals))] }
    end

    def hario_attributes(types, only: nil, except: nil)
      @hario_attributes_list ||= {}
      Array.wrap(types).each do |t|
        raise_if_not_hario_type!(t)
        @hario_attributes_list[t] =
          { only: Array.wrap(only), except: Array.wrap(except) }
      end
    end

    private
      def raise_if_not_hario_type!(type)
        unless HARIO_APPLY_TYPES.include?(type)
          raise ArgumentError, "#{type} is not one of " \
            "#{HARIO_APPLY_TYPES.map(&:inspect).join(', ')}"
        end
      end
  end
end
