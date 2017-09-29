module ActionCrud
  module Helpers
    class Url
      attr_accessor :record, :action, :options, :path, :url

      # Intialize url finder
      def initialize(context, record=nil, action=nil, *options)
        @context = context
        @record  = record || @context.try(:current_record) || @context.try(:record)
        @action  = action
        @options = options
        @path    = route_uri :path
        @url     = route_uri :url
      end

      # To string
      def to_s(type=:path)
        instance_variable_get("@#{type}").to_s
      end

      # Is index action
      def index?
        action == :index
      end

      # Should prefix method
      def prefix?
        action.in? [:new, :edit]
      end

      # Should include record
      def record?
        action.in? [:show, :edit, :delete, :destroy]
      end

      # Find route key
      def route_key
        singular = 'singular_' unless index?
        record.model_name.try :"#{singular}route_key"
      end

      # Find route method
      def route_uri(type)
        args   = [*options]
        args   = [record, *options] if record?
        method = "#{route_key}_#{type}"
        method = "#{action}_#{method}" if prefix?

        @context.try :"#{method}", *args
      end
    end
  end
end
