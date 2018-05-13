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
        requires :category, type: Integer, desc: 'Article category Id, type: Integer'
      end
      post :create do
        article = Article.new(title: params[:title], content: params[:content])
        ArticleCategory.find_or_create_by(category_id: params[:category], article_id: article.id)
        if article.save
          { status: 1, msg: 'create article success', id: article.id }
        else
          { status: 0, msg: article.errors.full_messages[0] }
        end
      end

      # example /api/articles/show
      desc 'show blog'
      params do
        requires :id, type: Integer, desc: 'Article id, type: Integer'
      end
      get :show do
        article = Article.find(params[:id])
        if article.present?
          {status: 1, msg: 'get article success'}.merge({article: article.attributes})
        else
          {status: 0, msg: 'get article error'}
        end
      end

      # example /api/articles/get_lists
      desc 'get create list'
      get :get_lists do
        Article.order(created_at: :desc).limit(10)
        Article.order(created_at: :desc).map do |article|
          article.attributes.merge({comment_count: article.comments.count})
        end
      end
    end

    resource :categries do
      # example /api/categries/get_lists
      desc 'get category list'
      get :get_lists do
        {status: 1, categries: Category.all}
      end
    end

    resource :category_articles do
      # example /api/category_articles/get_lists
      desc "get articles list of one category"
      params do
        requires :category, type: Integer, desc: 'Article category, type: Integer'
      end
      get :get_lists do
        category = Category.find(params[:category])
        if category.present?
          {status: 1, msg: 'get article list success', articles: category.articles.map(&:attributes)}
        else
          {status: 0, mes: 'get article list failed'}
        end
      end
    end
  end
end
