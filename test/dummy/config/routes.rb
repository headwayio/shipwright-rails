Rails.application.routes.draw do
  mount Shipwright::Engine => "/shipwright" if defined?(Shipwright::Engine)
  mount Lookbook::Engine, at: "/lookbook" if defined?(Lookbook::Engine)

  get "components" => "pages#components"
  root "pages#components"

  get "up" => "rails/health#show", as: :rails_health_check
end
