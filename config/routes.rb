NewsQSpike::Application.routes.draw do
  root 'feed_items#index'

  get "feed_items/index"

  devise_for :admin_users, ActiveAdmin::Devise.config
  devise_for :users
  ActiveAdmin.routes(self)
end
