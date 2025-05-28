# config/routes.rb
Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    resources :tags, only: [:index]
    resources :maps, only: [:index, :show] do
      member do
        get :prev
        get :next
      end
    end
  end
end
