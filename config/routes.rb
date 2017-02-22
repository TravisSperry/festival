Rails.application.routes.draw do
  devise_for :admins
  resources :registrations
  resources :students
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'registrations#new'

  as :admin do
    get 'admin', to: 'devise/sessions#new'
    delete 'logout', to: 'devise/sessions#destroy'
  end
end
