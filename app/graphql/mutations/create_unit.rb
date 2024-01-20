# frozen_string_literal: true

module Mutations
  class CreateUnit < BaseMutation
    description "Creates a unit by id"

    field :unit, Types::Unit::UnitType, null: true

    argument :id, ID, required: true
    argument :input, Types::Unit::UnitInputType, required: true

    def resolve(id:, input:)
      size = Unit.where(chapter_id: id).count
      unit = Unit.build_unit(
        input.to_h.merge(
          chapter_id: id,
          sort_key: size + 1
        )
      )
      { unit: unit } 
    rescue *EXCEPTIONS => e 
      GraphQL::ExecutionError.new(e.message)
    end
  end
end
