module ActionCrud
  module Pagination
    extend ActiveSupport::Concern

    included do
      # Action callbacks
      before_action :set_pagination_params, only: [:index]
    end

    private

      # Get pagination params
      def pagination_params
        params.permit(:page, :per_page).to_h
      end

      # Get pagination page
      def page
        pagination_params[:page]
      end

      # Get pagination per page
      def per_page
        pagination_params[:per_page]
      end

      # Set pagination parameters
      def set_pagination_params
        pagination                   = pagination_params[:page].is_a?(Hash) ? pagination_params[:page] : {}
        pagination_params[:page]     = pagination[:number] || pagination_params.fetch(:page, 1)
        pagination_params[:per_page] = pagination[:size]   || pagination_params.fetch(:per_page, 20)
      end

      # Paginate records
      def paginate(records)
        records.paginate(page: pagination_params[:page], per_page: pagination_params[:per_page])
      end

      # Pagination metadata
      def pagination_meta(records)
        {
          current_page:  pagination_params.fetch(:page, 1).to_i,
          next_page:     records.try(:next_page),
          previous_page: records.try(:previous_page),
          total_pages:   records.try(:total_pages),
          total_entries: records.try(:total_entries)
        }
      end
  end
end
