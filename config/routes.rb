Rails.application.routes.draw do
  mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "graphql#execute" if Rails.env.development?
  post "/graphql", to: "graphql#execute"
  
  namespace :api do
    namespace :v1 do
      resources :courses
    end
  end
  
end
