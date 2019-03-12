Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get  "/login/:user_id", to: "github#login", as: 'login'
  post "/telegram", to: "webhook#telegram"
end
