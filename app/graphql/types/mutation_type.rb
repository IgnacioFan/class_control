# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :create_course, mutation: Mutations::CreateCourse
    field :delete_course, mutation: Mutations::DeleteCourse
    field :update_course, mutation: Mutations::UpdateCourse

    field :reorder_chapter, mutation: Mutations::ReorderChapter
  end
end
