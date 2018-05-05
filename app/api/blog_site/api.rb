module BlogSite
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
      # example /api/articles/create
      desc 'create blog'
      params do
        requires :title, type: String, desc: 'Article title, type: String'
        requires :content, type: String, desc: 'Article content, type: Text'
      end
      post :create do
        begin
          puts "params: #{params}"
          Article.create!(title: params[:title], content: params[:content])
          msg = 'create article success'
        rescue => ex
          msg = ex.message
        end
        {status: 1, msg: msg}
      end
    end
  end
end
