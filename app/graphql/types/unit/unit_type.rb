# frozen_string_literal: true

class Types::Unit::UnitType < Types::BaseObject
  field :id, ID, null: false
  field :name, String, null: false
  field :description, String
  field :content, String, null: false
  field :sort_key, Integer, null: false
  field :chapter_id, Integer
  field :created_at, GraphQL::Types::ISO8601DateTime
  field :updated_at, GraphQL::Types::ISO8601DateTime
  field :deleted_at, GraphQL::Types::ISO8601DateTime
end
