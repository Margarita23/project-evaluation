Rails.application.routes.draw do
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'home#index'
  
  resources :projects
  devise_for :users, controllers: {registrations: "users/registrations"} do
    get "/signup" => "registrations#new", as: :new_user_registration
  end
  
  get "/reference" => "home#reference", as: :get_reference 
    
end
