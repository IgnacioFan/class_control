# frozen_string_literal: true

module Mutations
  class CreateUnit < BaseMutation
    description "Creates a unit"

    field :unit, Types::Unit::UnitType, null: true

    argument :course_id, ID, required: true
    argument :chapter_id, ID, required: true
    argument :input, Types::Unit::UnitInputType, required: true

    def resolve(course_id:, chapter_id:, input:)
      unit = Unit.build_unit(course_id, chapter_id, input.to_h)
      { unit: unit } 
    rescue *EXCEPTIONS => e 
      GraphQL::ExecutionError.new(e.summary)
    end
  end
end
