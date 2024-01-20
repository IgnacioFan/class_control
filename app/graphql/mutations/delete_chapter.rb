# frozen_string_literal: true

module Mutations
  class DeleteChapter < BaseMutation 
    description "Deletes a chapter by ID"
    
    field :chapter, Types::Chapter::ChapterType, null: true
  
    argument :id, ID, required: true
  
    def resolve(id: )
      chapter = Chapter.find(id)
      if chapter.destroy
        { chapter: chapter }
      end
    rescue ActiveRecord::RecordNotFound => e 
      GraphQL::ExecutionError.new(e.message)
    end
  end
end

