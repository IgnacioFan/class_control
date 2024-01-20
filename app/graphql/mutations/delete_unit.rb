# frozen_string_literal: true

module Mutations
  class DeleteUnit < BaseMutation 
    description "Deletes a unit by ID"
    
    field :unit, Types::Unit::UnitType, null: true
  
    argument :id, ID, required: true
  
    def resolve(id: )
      unit = Unit.find(id)
      if unit.destroy
        { unit: unit }
      end
    rescue ActiveRecord::RecordNotFound => e 
      GraphQL::ExecutionError.new(e.message)
    end
  end
end

