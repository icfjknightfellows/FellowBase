Rails.application.routes.draw do

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  devise_for :users

  get '/report', to: "reports#index", as: "report"
  get '/links/all', to: "reports#all", as: "all_digital_asset"
  get '/links/successful', to: "reports#successful", as: "successful_digital_asset"
  get '/links/errored', to: "reports#errored", as: "errored_digital_asset"
  get '/links/with-no-data', to: "reports#with_no_data", as: "digital_asset_with_no_data"
  get '/links/search', to: "reports#search", as: "digital_asset_search"

  post '/user/set_selected_dimensions', to: "static_pages#set_selected_dimensions", as: "set_selected_dimensions"

  root 'static_pages#index'

end
