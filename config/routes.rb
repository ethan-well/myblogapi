Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount BlogSite::API => '/'
  root to: "myblog#index"
  get 'test_pjax', to: 'myblog#test_pjax'
end
