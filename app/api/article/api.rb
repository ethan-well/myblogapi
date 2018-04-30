module Article
  class API < Grape::API
    version 'v1', using: :header, vendor: 'wewin'
    format :json
    prefix :api

    helpers do
      def current_user
        @current_user ||= User.authorize!(env)
      end

      def authenticate!
        error!('401 Unauthorized', 401) unless current_user
      end
    end

    resource :articles do
      # example api/articles/get_articles_list?type='React'
      desc 'get article list'
      params do
        requires :type, type: String, desc: 'Article kind type: JavaScript, '
      end
      get :get_articles_list do
        {
          code: 200,
          type: params[:type],
          message: 'api is ok'
        }
      end
    end
  end
end
