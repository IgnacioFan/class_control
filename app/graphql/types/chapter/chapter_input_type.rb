# frozen_string_literal: true

class Types::Chapter::ChapterInputType < Types::BaseInputObject
  argument :id, ID, required: false
  argument :name, String, required: true
  argument :sort_key, Int, required: false
  argument :units, [Types::Unit::UnitInputType], required: false
end
