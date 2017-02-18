Rails.application.routes.draw do

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  devise_for :users

  get '/report', to: "reports#index", as: "report"
  # get '/links/all', to: "reports#all", as: "all_digital_asset"
  # get '/links/successful', to: "reports#successful", as: "successful_digital_asset"
  # get '/links/errored', to: "reports#errored", as: "errored_digital_asset"
  # get '/links/with-no-data', to: "reports#with_no_data", as: "digital_asset_with_no_data"
  get '/digital_assets', to: "reports#digital_assets", as: "digital_assets"

  root 'static_pages#index'

end
