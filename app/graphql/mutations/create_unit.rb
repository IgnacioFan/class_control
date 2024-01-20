# frozen_string_literal: true

module Mutations
  class CreateUnit < BaseMutation
    description "Creates a unit by chapter ID"

    field :unit, Types::Unit::UnitType, null: true

    argument :id, ID, required: true
    argument :input, Types::Unit::UnitInputType, required: true

    def resolve(id:, input:)
      chapter = Chapter.includes(:units).find(id)
      unit = chapter.units.build(input.to_h)
      unit.sort_key = chapter.units.size
      # debugger
      { unit: unit } if unit.save!
    rescue ActiveRecord::RecordNotFound => e 
      GraphQL::ExecutionError.new(e.message)
    end
  end
end
