require 'active_support/concern'

module Blog
  module ControllerHelpers
    module Auth
      extend ActiveSupport::Concern
      include SessionsHelper

      included do
        before_filter :authenticate_user!
      end

      private
      def authenticate_user!
         if current_user.nil?
           redirect_to blog.admin_login_url, alert: I18n.t('blog.admin.login.need_auth')
         end
      end
    end
  end
end