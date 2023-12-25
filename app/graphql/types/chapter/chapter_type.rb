# frozen_string_literal: true

class Types::Chapter::ChapterType < Types::BaseObject
  field :id, ID, null: false
  field :name, String, null: false
  field :sort_key, Integer, null: false
  field :course_id, Integer
  field :created_at, GraphQL::Types::ISO8601DateTime
  field :updated_at, GraphQL::Types::ISO8601DateTime
  field :deleted_at, GraphQL::Types::ISO8601DateTime
  field :units, [Types::Unit::UnitType], null: true
end
