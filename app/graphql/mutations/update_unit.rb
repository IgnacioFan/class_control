# # frozen_string_literal: true

module Mutations
  class UpdateUnit < BaseMutation 
    description "Updates a unit by id"

    field :unit, Types::Unit::UnitType, null: true
  
    argument :id, ID, required: true
    argument :input, Types::Unit::UnitInputType, required: true
  
    def resolve(id:, input:)
      unit = Unit.update_unit_by(id, input.to_h)
      { unit: unit }
    rescue *EXCEPTIONS => e 
      GraphQL::ExecutionError.new(e.message)
    end
  end
end
