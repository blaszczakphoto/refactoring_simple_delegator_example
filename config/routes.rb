Rails.application.routes.draw do
  get "callback", to: "payment_gateway#callback"
  get "successful_order/:id", to: "application#index", as: :successful_order
  get "retry_order/:id", to: "application#index", as: :retry_order
  get "missing_order/:id", to: "application#index", as: :missing_order
  get "failed_order/:id", to: "application#index", as: :failed_order
end
