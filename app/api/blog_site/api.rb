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
      # example /api/articles
      desc 'create blog'
      params do
        requires :title, type: String, desc: 'Article title, type: String'
        requires :content, type: String, desc: 'Article content, type: Text'
        requires :category, type: Integer, desc: 'Article category Id, type: Integer'
      end
      post do
        article = Article.new(title: params[:title], content: params[:content], category_id: params[:category])
        if article.save
          { status: 1, msg: 'create article success', id: article.id }
        else
          { status: 0, msg: article.errors.full_messages[0] }
        end
      end

      # example /api/articles/:id
      desc 'show blog'
      params do
        requires :id, type: Integer, desc: 'Article id, type: Integer'
      end
      get ':id' do
        article = Article.find(params[:id])
        if article.present?
          {status: 1, msg: 'get article success'}.merge({article: article.attributes})
        else
          {status: 0, msg: 'get article error'}
        end
      end

      # example /api/articles
      desc 'get create list'
      get do
        Article.order(created_at: :desc).limit(10).map do |article|
          article.attributes.merge({comment_count: article.comments.count})
        end
      end

      # example /api/articles/:id
      desc 'edit article'
      params do
        requires :id, type: Integer, desc: 'Article ID.'
        requires :title, type: String, desc: 'Article title, type: String'
        requires :content, type: String, desc: 'Article content, type: Text'
        requires :category, type: Integer, desc: 'Article category Id, type: Integer'
      end
      put ':id' do
        begin
          article = Article.find(params[:id])
          article.update_attributes!(title: params[:title], content: params[:content], category_id: params[:category])
          { status: 1, msg: 'update article success', id: article.id }
        rescue => ex
          { status: 0, msg: "update article false: #{ex.message}"}
        end
      end

      # example /api/articles/:id
      desc 'delete article'
      delete ':id' do
        begin
          article = Article.find(params[:id])
          article.destroy!
          {status: 1, msg: 'delete article success', id: params[:id]}
        rescue => ex
          {status: 0, message: "delete article failed: #{ex.message}"}
        end
      end
    end

    resource :categories do
      # example /api/categories
      desc 'get category list'
      get do
        {status: 1, categories: Category.all}
      end

      resource ':id' do
        # example /api/categories/:id/articles
        get 'articles' do
          category = Category.find(params[:id])
          if category.present?
            {status: 1, msg: 'get article list success', articles: category.articles.map(&:attributes)}
          else
            {status: 0, mes: 'get article list failed'}
          end
        end
      end
    end

    resource :category_articles do
      # example /api/category_articles/:id
      desc "get articles list of one category"
      params do
        requires :id, type: Integer, desc: 'Category ID, type: Integer'
      end
      get ':id' do
        category = Category.find(params[:id])
        if category.present?
          {status: 1, msg: 'get article list success', articles: category.articles.map(&:attributes)}
        else
          {status: 0, mes: 'get article list failed'}
        end
      end
    end
  end
end
