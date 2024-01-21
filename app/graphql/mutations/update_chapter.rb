# # frozen_string_literal: true

module Mutations
  class UpdateChapter < BaseMutation 
    description "Updates a chapter by id"
    
    field :chapter, Types::Chapter::ChapterType, null: true
  
    argument :id, ID, required: true
    argument :input, Types::Chapter::ChapterInputType, required: true
  
    def resolve(id:, input:)
      chapter = Chapter.update_chapter_by(id, input.to_h)
      { chapter: chapter }
    rescue *EXCEPTIONS => e 
      GraphQL::ExecutionError.new(e.message)
    end
  end
end
