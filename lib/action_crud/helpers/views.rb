module ActionCrud
  module Helpers
    module Views
      # Get current model
      def current_model
        controller.try(:model)
      end

      # Get current record
      def current_record
        controller.try(:record) || current_model.try(:new)
      end

      # Get current records
      def current_records
        controller.try(:records) || []
      end

      # Get permitted parameters
      def permitted_parameters
        controller.try(:permitted_parameters) || []
      end
    end
  end
end
