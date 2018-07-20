Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount BlogSite::API => '/'
  root to: "myblog#index"
  resources :myblog, only: [:inde] do
    collection do
      get :test
    end 
  end
end
