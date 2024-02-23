# frozen_string_literal: true

module Resolvers
  class CourseById < BaseResolver
    description "Gets a course"

    type Types::Course::CourseType, null: false

    argument :id, ID, required: true
    
    def resolve(id:)
      Course.find(id)
    rescue *EXCEPTIONS => e 
      GraphQL::ExecutionError.new(e.summary)
    end
  end
end
