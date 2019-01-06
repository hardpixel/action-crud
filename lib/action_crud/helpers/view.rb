module ActionCrud
  module Helpers
    module View
      def current_model
        controller.try(:current_model)
      end

      def current_record
        controller.try(:current_record) || current_model.try(:new)
      end

      def current_records
        controller.try(:current_records) || []
      end

      def permitted_params
        controller.try(:permitted_params) || []
      end

      def record_link_to(record=nil, *args)
        options = args.extract_options!
        action  = args.first

        ActionCrud::Helpers::Link.new(self, record, action, options).render
      end

      def record_links_to(record=nil, *args)
        options = args.extract_options!
        default = options.fetch :html, {}
        options = options.except(:html)
        actions = args.concat(options.keys)
        actions = actions.any? ? actions : [:show, :edit, :destroy]

        ActionCrud::Helpers::Link.new(self, record, actions, default).render_multiple(options)
      end
    end
  end
end
