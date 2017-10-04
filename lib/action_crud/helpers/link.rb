module ActionCrud
  module Helpers
    class Link
      attr_accessor :record, :action, :label, :options

      # Initialize link generator
      def initialize(context, record=nil, action=nil, *args)
        @options = args.extract_options!
        @context = context
        @record  = record || @context.try(:current_record)
        @action  = action
        @label   = options.fetch :label, nil
        @options = options.except :label

        if delete?
          @options.reverse_merge!(method: :delete, data: { confirm: 'Are you sure?' })
        end
      end

      # Is delete action
      def delete?
        action.in? [:delete, :destroy]
      end

      # Get link label
      def action_label
        label || "#{action}".humanize
      end

      # Get record path
      def record_path
        ActionCrud::Helpers::Route.new(@context, record, action).path || "#{action}"
      end

      # Render multiple
      def render_multiple(*args)
        default = options
        options = args.extract_options!
        actions = args.concat(action).concat(options.keys)
        links   = actions.uniq.map do |item|
          args = Hash(options[item]).reverse_merge(default)
          ActionCrud::Helpers::Link.new(@context, record, item, args).render
        end

        links.join.html_safe
      end

      # Render link
      def render
        @context.link_to action_label, record_path, options if record_path.present?
      end
    end
  end
end
