module ActionCrud
  module Pagination
    extend ActiveSupport::Concern

    included do
      class_attribute :per_page, instance_predicate: false

      self.per_page = 20

      before_action :set_pagination_params, only: [:index]
    end

    class_methods do
      def set_per_page(limit)
        self.per_page = limit.to_i
      end
    end

    private

    def pagination_params
      @pagination_params ||= params.permit(:page, :per_page).to_h.deep_symbolize_keys
    end

    def set_pagination_params
      pagination                   = pagination_params[:page].is_a?(Hash) ? pagination_params[:page] : {}
      pagination_params[:page]     = pagination[:number] || pagination_params.fetch(:page, 1)
      pagination_params[:per_page] = pagination[:size]   || pagination_params.fetch(:per_page, per_page)
    end

    def paginate(records)
      if records.respond_to? :paginate
        records.paginate(pagination_params.select { |k, _v| k.in? [:page, :per_page] })
      else
        records
      end
    end

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
