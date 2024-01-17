# # frozen_string_literal: true

module Mutations
  class UpdateUnit < BaseMutation 
    description "Updates a unit by unit ID"

    field :unit, Types::Unit::UnitType, null: true
  
    argument :id, ID, required: true
    argument :input, Types::Unit::UnitInputType, required: true
  
    def resolve(id:, input: )
      unit = Unit.find(id)
      unit.assign_attributes(input.to_h)
      unit.save
      { unit: unit }
    rescue ActiveRecord::RecordNotFound => e 
      GraphQL::ExecutionError.new(e.message)
    end
  end
end
