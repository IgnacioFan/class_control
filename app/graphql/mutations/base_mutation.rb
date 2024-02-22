# frozen_string_literal: true

module Mutations
  class BaseMutation < GraphQL::Schema::Mutation
    EXCEPTIONS = [
      ActiveRecord::RecordInvalid, 
      ActiveRecord::RecordNotFound, 
      Mongoid::Errors::Validations, 
      Mongoid::Errors::DocumentNotFound,
    ]

    null false
  end
end
