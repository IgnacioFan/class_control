# frozen_string_literal: true

module Mutations
  class DeleteChapter < BaseMutation 
    description "Deletes a chapter by id"
    
    field :chapter, Types::Chapter::ChapterType, null: true
  
    argument :id, ID, required: true
  
    def resolve(id:)
      chapter = Chapter.find(id)
      { chapter: chapter } if chapter.destroy
    rescue *EXCEPTIONS => e 
      GraphQL::ExecutionError.new(e.message)
    end
  end
end

