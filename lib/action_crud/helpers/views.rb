module ActionCrud
  module Helpers
    module Views
      # Get current model
      def current_model
        controller.try(:current_model)
      end

      # Get current record
      def current_record
        controller.try(:current_record) || current_model.try(:new)
      end

      # Get current records
      def current_records
        controller.try(:current_records) || []
      end

      # Get permitted parameters
      def permitted_params
        controller.try(:permitted_params) || []
      end

      # Get record link
      def record_link_to(record=nil, *args)
        options = args.extract_options!
        action  = args.first

        ActionCrud::Helpers::Link.new(self, record, action, options).render
      end

      # Get record links
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
