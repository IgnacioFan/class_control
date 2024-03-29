Rails.application.routes.draw do
  mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "graphql#execute" if Rails.env.development?
  post "/graphql", to: "graphql#execute"
end
