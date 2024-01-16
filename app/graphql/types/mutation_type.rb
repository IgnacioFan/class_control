# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :create_course, mutation: Mutations::CreateCourse
    field :delete_course, mutation: Mutations::DeleteCourse
    field :update_course, mutation: Mutations::UpdateCourse
    
    field :create_chapter, mutation: Mutations::CreateChapter
    field :update_chapter, mutation: Mutations::UpdateChapter
    field :reorder_chapters, mutation: Mutations::ReorderChapters
    # field :reorder_unit, mutation: Mutations::ReorderUnit
  end
end
