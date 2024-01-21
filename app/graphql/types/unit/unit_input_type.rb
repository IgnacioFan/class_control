# frozen_string_literal: true

module Types
  module Unit
    class UnitInputType < Types::BaseInputObject
      argument :id, ID, required: false
      argument :name, String, required: true
      argument :description, String, required: false
      argument :content, String, required: true
    end
  end
end
