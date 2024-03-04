# frozen_string_literal: true

module Mutations
  class PermissionError < StandardError
    def initialize(msg="permission denied")
      super(msg)
    end
  end
  
  class BaseMutation < GraphQL::Schema::Mutation
    EXCEPTIONS = [
      Mutations::PermissionError,
      ActiveRecord::RecordInvalid, 
      ActiveRecord::RecordNotFound, 
      Mongoid::Errors::Validations, 
      Mongoid::Errors::DocumentNotFound,
    ]

    null false

    def permission_denied!
      raise PermissionError unless context[:current_user]
    end
  end
end
