# frozen_string_literal: true

class Types::Course::CourseType < Types::BaseObject  
  field :id, ID, null: false
  field :name, String, null: false
  field :description, String
  field :created_at, GraphQL::Types::ISO8601DateTime
  field :updated_at, GraphQL::Types::ISO8601DateTime
  field :deleted_at, GraphQL::Types::ISO8601DateTime
  field :chapters, [Types::Chapter::ChapterType], null: false
end
