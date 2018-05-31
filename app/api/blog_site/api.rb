module BlogSite
  class API < Grape::API
    version 'v1', using: :header, vendor: 'wewin'
    format :json
    prefix :api

    helpers do
      def authenticate!
        error!('Unauthorized. Invalid or expired token.', 401) unless current_user
      end

      def current_user
        # find token. Check if valid.
        access_token = ApiKey.where(access_token: params[:access_token]).first
        if access_token && !access_token.is_expired?
          @current_user = User.find(access_token.user_id)
        else
          false
        end
      end
    end

    mount BlogSite::Auth
    mount BlogSite::Articles
  end
end
