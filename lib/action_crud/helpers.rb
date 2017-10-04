require 'action_crud/helpers/url'
require 'action_crud/helpers/link'
require 'action_crud/helpers/view'

module ActionCrud
  module Helpers
    # Get record path
    def record_path(*args)
      options = args.extract_options!
      record  = args.first

      ActionCrud::Helpers::Url.new(self, record, :show, options).path
    end

    # Get record absolute url
    def record_url(*args)
      options = args.extract_options!
      record  = args.first

      ActionCrud::Helpers::Url.new(self, record, :show, options).url
    end

    # Get records index path
    def records_path(*args)
      options = args.extract_options!
      record  = args.first

      ActionCrud::Helpers::Url.new(self, record, :index, options).path
    end

    # Get records index absolute url
    def records_url(*args)
      options = args.extract_options!
      record  = args.first

      ActionCrud::Helpers::Url.new(self, record, :index, options).url
    end

    # Get record new path
    def new_record_path(*args)
      options = args.extract_options!
      record  = args.first

      ActionCrud::Helpers::Url.new(self, record, :new, options).path
    end

    # Get record new absolute url
    def new_record_url(*args)
      options = args.extract_options!
      record  = args.first

      ActionCrud::Helpers::Url.new(self, record, :new, options).url
    end

    # Get record edit path
    def edit_record_path(*args)
      options = args.extract_options!
      record  = args.first

      ActionCrud::Helpers::Url.new(self, record, :edit, options).path
    end

    # Get record edit absolute url
    def edit_record_url(*args)
      options = args.extract_options!
      record  = args.first

      ActionCrud::Helpers::Url.new(self, record, :edit, options).url
    end
  end
end
