# frozen_string_literal: true

module Mutations
  class CreateChapter < BaseMutation
    description "Creates a chapter by id"

    field :chapter, Types::Chapter::ChapterType, null: true
    
    argument :id, ID, required: true
    argument :input, Types::Chapter::ChapterInputType, required: true

    def resolve(id:, input:)
      chapter = Chapter.build_chapter(
        input.to_h.merge(
          course_id: id,
          sort_key: new_chapter_sort_key(id)
        )
      )
      { chapter: chapter } 
    rescue *EXCEPTIONS => e
      GraphQL::ExecutionError.new(e.message)
    end

    private

    def new_chapter_sort_key(id)
      Chapter.where(course_id: id).count + 1
    end
  end
end
