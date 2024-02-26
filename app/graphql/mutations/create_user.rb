# frozen_string_literal: true

module Mutations
  class CreateUser < BaseMutation
    description "Creates a user"

    field :user, Types::User::UserType, null: true
 
    class AuthProviderSignupData < Types::BaseInputObject
      argument :credentials, Types::User::AuthProviderCredentialsInput, required: false
    end
    
    argument :name, String, required: true
    argument :auth_provider, AuthProviderSignupData, required: false
    
    def resolve(name:, auth_provider:)
      user = User.create!(
        name: name,
        email: auth_provider&.[](:credentials)&.[](:email),
        password: auth_provider&.[](:credentials)&.[](:password)
      )
      { user: user } 
    rescue *EXCEPTIONS => e
      GraphQL::ExecutionError.new(e.message)
    end
  end
end
