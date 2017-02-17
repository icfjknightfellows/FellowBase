Rails.application.routes.draw do

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  devise_for :users

  get '/report', to: "reports#index", as: "report"
  get '/digital_assets', to: "reports#digital_assets", as: "digital_assets"

  root 'static_pages#index'

end
