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

      # example /api/articles/show
      desc 'show blog'
      params do
        requires :id, type: Integer, desc: 'Article id, type: Integer'
      end
      get :show do
        article = Article.find(params[:id])
        if article.present?
          {status: 1, msg: 'get article success'}.merge(article.attributes)
        else
          {status: 0, msg: 'get article error'}
        end
      end

    end
  end
end
