Rails.application.routes.draw do
  resources :applications, only: [ :show, :edit, :update ]
  root "applications#show"
end
