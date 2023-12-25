# frozen_string_literal: true

class Types::Unit::UnitInputType < Types::BaseInputObject
  argument :name, String, required: true
  argument :description, String, required: false
  argument :content, String, required: true
  argument :sort_key, Int, required: false
end
