module ActionCrud
  module Helpers
    class Route
      attr_accessor :model, :record, :action, :options, :path, :url

      # Intialize url finder
      def initialize(context, record = nil, action = nil, *options)
        @context = context
        @record  = record || @context.try(:current_record)
        @action  = action
        @options = Hash(options.first)
        @path    = route_uri true
        @url     = route_uri false
      end

      # To string
      def to_s(type = :path)
        instance_variable_get("@#{type}").to_s
      end

      # Should include record
      def record?
        action.in? [:show, :edit, :delete, :destroy]
      end

      # Get model name
      def model(method = 'singular')
        @record.class.model_name.send(method).to_sym unless @record.nil?
      end

      # Get route namespace
      def namespace
        if @context.respond_to? :controller
          @context.controller.try(:namespace)
        else
          @context.try(:namespace)
        end
      end

      # Get namespaced record
      def namespaced_record
        if action == :edit
          namespace.present? ? [:edit, namespace, record] : [:edit, record]
        else
          namespace.present? ? [namespace, record] : [record]
        end
      end

      # Get namespaced model
      def namespaced_model
        if action == :new
          namespace.present? ? [:new, namespace, model] : [:new, model]
        else
          namespace.present? ? [namespace, model('plural')] : model('plural')
        end
      end

      # Find route method
      def route_uri(only_path = false)
        args = record? ? namespaced_record : namespaced_model
        args = [args, options.merge(only_path: only_path)].flatten.reject(&:blank?)

        @context.url_for(args)
      end
    end
  end
end
