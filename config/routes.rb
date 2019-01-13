Rails.application.routes.draw do
  
  root to: 'home#index'
  
  devise_for :users, controllers: {registrations: "users/registrations"} do
    get "/signup" => "registrations#new", as: :new_user_registration
  end
  
  get "/reference" => "home#reference", as: :get_reference 
  
  resources :projects do
    resources :opportunities
    resources :benefits
    resources :costs
    resources :risks
  end
  
  resources :compare_projects
    
end
