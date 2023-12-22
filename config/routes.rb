Rails.application.routes.draw do
  post "/graphql", to: "graphql#execute"
  
  namespace :api do
    namespace :v1 do
      resources :courses
    end
  end
  
end
