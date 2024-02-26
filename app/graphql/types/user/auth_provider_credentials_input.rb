# frozen_string_literal: true

module Types
  module User
    class AuthProviderCredentialsInput < Types::BaseInputObject
      graphql_name "AUTH_PROVIDER_CREDENTIALS"

      argument :email, String, required: true
      argument :password, String, required: true
    end
  end
end
