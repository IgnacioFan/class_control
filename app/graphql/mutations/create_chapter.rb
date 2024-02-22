# frozen_string_literal: true

module Mutations
  class CreateChapter < BaseMutation
    description "Creates a chapter with units"

    field :chapter, Types::Chapter::ChapterType, null: true
    
    argument :course_id, ID, required: true
    argument :input, Types::Chapter::ChapterInputType, required: true

    def resolve(course_id:, input:)
      chapter = Chapter.build_chapter(course_id, input.to_h)
      { chapter: chapter } 
    rescue *EXCEPTIONS => e
      GraphQL::ExecutionError.new(e.summary)
    end
  end
end
