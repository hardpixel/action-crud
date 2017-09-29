require 'action_crud/controller'
require 'action_crud/pagination'
require 'action_crud/helpers'
require 'action_crud/version'

module ActionCrud
  extend ActiveSupport::Concern

  included do
    # Include submodules
    include ActionCrud::Controller
    include ActionCrud::Pagination
  end
end

# Include action view helpers
if defined? ActionView::Base
  ActionView::Base.send :include, ActionCrud::Helpers
  ActionView::Base.send :include, ActionCrud::Helpers::Records
end

# Include action controller helpers
if defined? ActionController::Base
  ActionController::Base.send :include, ActionCrud::Helpers
end
