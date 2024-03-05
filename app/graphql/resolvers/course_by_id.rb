# frozen_string_literal: true

module Resolvers
  class CourseById < BaseResolver
    description "Gets a course"

    type Types::Course::CourseType, null: false

    argument :id, ID, required: true
    
    def resolve(id:)
      permission_denied!

      Course.find(id)
    rescue *EXCEPTIONS => e 
      GraphQL::ExecutionError.new(e)
    end
  end
end
