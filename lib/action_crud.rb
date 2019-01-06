require 'active_support'
require 'action_crud/controller'
require 'action_crud/pagination'
require 'action_crud/helpers/route'
require 'action_crud/helpers/link'
require 'action_crud/helpers/url'
require 'action_crud/helpers/view'
require 'action_crud/version'

module ActionCrud
  extend ActiveSupport::Concern

  included do
    include ActionCrud::Controller
    include ActionCrud::Pagination
  end
end

if defined? ActionView::Base
  ActionView::Base.send :include, ActionCrud::Helpers::Url
  ActionView::Base.send :include, ActionCrud::Helpers::View
end

if defined? ActionController::Base
  ActionController::Base.send :include, ActionCrud::Helpers::Url
end
