# frozen_string_literal: true

module Mutations
  class DeleteUnit < BaseMutation 
    description "Deletes a unit by id"
    
    field :unit, Types::Unit::UnitType, null: true
  
    argument :id, ID, required: true
  
    def resolve(id:)
      unit = Unit.find(id)
      { unit: unit } if unit.destroy
    rescue *EXCEPTIONS => e 
      GraphQL::ExecutionError.new(e.message)
    end
  end
end

