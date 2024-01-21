# frozen_string_literal: true

module Types
  module Chapter
    class ChapterInputType < Types::BaseInputObject
      argument :id, ID, required: false
      argument :name, String, required: true
      argument :units, [Types::Unit::UnitInputType], required: false
    end
  end
end
