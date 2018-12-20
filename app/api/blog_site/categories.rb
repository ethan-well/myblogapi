module BlogSite
  class Categories < Grape::API
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
  end
end