# frozen_string_literal: true

module Resolvers
  class ChapterById < BaseResolver
    description "Gets a chapter by id"

    type Types::Chapter::ChapterType, null: false

    argument :id, ID, required: true
    
    def resolve(id:)
      Chapter.find(id)
    rescue ActiveRecord::RecordNotFound => e 
      GraphQL::ExecutionError.new(e.message)
    end
  end
end
