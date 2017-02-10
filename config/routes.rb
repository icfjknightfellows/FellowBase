Rails.application.routes.draw do

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  devise_for :users

  get '/report', to: "reports#index", as: "report"

  root 'static_pages#index'

end
