module BlogSite
  class Articles < Grape::API
    resource :articles do
      # example /api/articles
      desc 'create blog'
      params do
        requires :title, type: String, desc: 'Article title, type: String'
        requires :content, type: String, desc: 'Article content, type: Text'
        requires :category, type: Integer, desc: 'Article category id, type: Integer'
        requires :private, type: Boolean, desc: 'Article private state, type: Boolean'
      end
      post do
        authenticate!
        article_attr = {
          title: params[:title],
          content: params[:content],
          category_id: params[:category],
          user_id: current_user.id,
          private: params[:private]
        }
        article = Article.new(article_attr)
        if article.save!
          { status: 1, msg: 'create article success', id: article.id, length: params[:content].length, private: params[:private] }
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
        can_manage = current_user && current_user.id == article.user_id
        if article.present?
          {
            status: 1,
            msg: 'get article success',
            article: article.attributes,
            length: article.content.length,
            can_manage: can_manage,
            private: article.private
          }
        else
          {status: 0, msg: 'get article error'}
        end
      end

      # example /api/articles
      desc 'get article list'
      get do
        Article.order(updated_at: :desc).limit(10).map do |article|
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
        authenticate!
        begin
          article = current_user.articles.find(params[:id])
          article_attr = {
            title: params[:title],
            content: params[:content],
            category_id: params[:category],
            private: params[:private]
          }
          article.update_attributes!(article_attr)
          { status: 1, msg: 'update article success', id: article.id, length: params[:content].length }
        rescue => ex
          { status: 0, msg: "update article false: #{ex.message}"}
        end
      end

      # example /api/articles/:id
      desc 'delete article'
      delete ':id' do
        authenticate!
        begin
          article = current_user.articles.find(params[:id])
          article.destroy!
          {status: 1, msg: 'delete article success', id: params[:id]}
        rescue => ex
          {status: 0, message: "delete article failed: #{ex.message}"}
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
          { status: 1, msg: 'get article list success', articles: category.articles.map(&:attributes) }
        else
          { status: 0, mes: 'get article list failed' }
        end
      end
    end
  end
end
