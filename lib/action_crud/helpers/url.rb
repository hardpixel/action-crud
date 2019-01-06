module ActionCrud
  module Helpers
    module Url
      def record_path(*args)
        options = args.extract_options!
        record  = args.first

        ActionCrud::Helpers::Route.new(self, record, :show, options).path
      end

      def record_url(*args)
        options = args.extract_options!
        record  = args.first

        ActionCrud::Helpers::Route.new(self, record, :show, options).url
      end

      def records_path(*args)
        options = args.extract_options!
        record  = args.first

        ActionCrud::Helpers::Route.new(self, record, :index, options).path
      end

      def records_url(*args)
        options = args.extract_options!
        record  = args.first

        ActionCrud::Helpers::Route.new(self, record, :index, options).url
      end

      def new_record_path(*args)
        options = args.extract_options!
        record  = args.first

        ActionCrud::Helpers::Route.new(self, record, :new, options).path
      end

      def new_record_url(*args)
        options = args.extract_options!
        record  = args.first

        ActionCrud::Helpers::Route.new(self, record, :new, options).url
      end

      def edit_record_path(*args)
        options = args.extract_options!
        record  = args.first

        ActionCrud::Helpers::Route.new(self, record, :edit, options).path
      end

      def edit_record_url(*args)
        options = args.extract_options!
        record  = args.first

        ActionCrud::Helpers::Route.new(self, record, :edit, options).url
      end
    end
  end
end
