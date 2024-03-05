# frozen_string_literal: true

module Resolvers
  class ChapterById < BaseResolver
    description "Gets a chapter"

    type Types::Chapter::ChapterType, null: false

    argument :course_id, ID, required: true
    argument :chapter_id, ID, required: true
    
    def resolve(course_id:, chapter_id:)
      permission_denied!

      course = Course.find(course_id)
      course.chapters.find(chapter_id)
    rescue *EXCEPTIONS => e 
      GraphQL::ExecutionError.new(e)
    end
  end
end
