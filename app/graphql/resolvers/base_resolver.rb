# frozen_string_literal: true

module Resolvers
  class BaseResolver < GraphQL::Schema::Resolver
    EXCEPTIONS = [
      ActiveRecord::RecordInvalid, 
      ActiveRecord::RecordNotFound, 
      Mongoid::Errors::Validations, 
      Mongoid::Errors::DocumentNotFound,
    ]

    null false
  end
end
