# frozen_string_literal: true

module Mutations
  class SignInUser < BaseMutation
    description "Sign in a user"
    
    field :token, String, null: true
    field :user, Types::User::UserType, null: true

    argument :credentials, Types::User::AuthProviderCredentialsInput, required: true

    def resolve(credentials:)
      user = User.find_by(email: credentials[:email])
      return GraphQL::ExecutionError.new("invalid email/password") unless user && user.authenticate(credentials[:password])

      token = gen_token(user)

      { user: user, token: token }
    rescue *EXCEPTIONS => e 
      GraphQL::ExecutionError.new(e.message)
    end

    private

    def gen_token(user)
      JsonWebToken.encode({ user_id: user.id })
    end
  end
end
