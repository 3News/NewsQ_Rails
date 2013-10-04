NewsQSpike::Application.routes.draw do
  devise_for :users
  root 'feeds#index'
end
