Rails.application.routes.draw do
  root "orders#index"

  get "/articles", to: "orders#index"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
