# frozen_string_literal: true

module Resolvers
  class UnitById < BaseResolver
    description "Gets Unit by ID"

    type Types::Unit::UnitType, null: false

    argument :id, ID, required: true
    
    def resolve(id:)
      Unit.find(id)
    rescue ActiveRecord::RecordNotFound => e 
      GraphQL::ExecutionError.new(e.message)
    end
  end
end
