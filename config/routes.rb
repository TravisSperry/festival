Rails.application.routes.draw do
  devise_for :admins
  namespace :festival do
    resources :registrations
  end
  resources :students
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'festival/registrations#new'

  as :admin do
    get 'admin', to: 'devise/sessions#new'
    delete 'logout', to: 'devise/sessions#destroy'
  end
end
