# frozen_string_literal: true

module Mutations
  class DeleteChapter < BaseMutation 
    description "Deletes a chapter, including units"
    
    field :chapter, Types::Chapter::ChapterType, null: true
  
    argument :course_id, ID, required: true
    argument :chapter_id, ID, required: true
  
    def resolve(course_id:, chapter_id:)
      permission_denied!
      
      course = Course.find(course_id)
      chapter = course.chapters.find(chapter_id)
      if chapter.destroy
        { chapter: chapter }
      else
        GraphQL::ExecutionError.new("failed to delete the chapter")
      end 
    rescue *EXCEPTIONS => e 
      GraphQL::ExecutionError.new(e)
    end
  end
end

