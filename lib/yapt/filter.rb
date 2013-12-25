require 'pry'
require "chronic"

module Yapt
  class Filter
    def self.parse(args)
      args.inject({filter: ""}) do |query, arg|
        filter = new(arg)
        # binding.pry
        if filter.filter?
          query[:filter] += "#{filter.to_filter} "
        else
          query[filter.key] = filter.val
        end
        query
      end
    end

    def filter?
      not %w(limit offset).include?(key)
    end

    attr_reader :key, :val
    def initialize(a,b=nil)
      if b
        @key, @val = a.to_s, b.to_s
      else
        k, v = a.split(/[:=]/)
        v ? (@key, @val = k, v) : @val = k
      end
      clean_key!
      clean_val!
    end

    def keyword?
      !key
    end

    def to_filter
      keyword? ? val : coloned
    end

    private

    def coloned
      %{#{key}:"#{val}"}
    end

    def clean_key!
      # ???
    end

    def clean_val!
      if val
        if time_filter_fields.include?(key)
          @val = dated(Chronic.parse(val))
        end
      end
    end

    def time_filter_fields
      @time_filter_fields ||= %w(created modified updated accepted).collect do |event|
        ["", "on", "since", "before"].collect do |timing|
          "#{event}_#{timing}".sub(/_\Z/,'')
        end
      end.flatten
    end

    def dated(time)
      Date.parse(time.strftime('%Y/%m/%d'))
    end
    # if val
    # if time_filter_fields.include?(key)
      # val = dated(Chronic.parse(val))
    # end

  end
end
