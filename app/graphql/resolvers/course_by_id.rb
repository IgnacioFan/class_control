# frozen_string_literal: true

module Resolvers
  class CourseById < BaseResolver
    description "Gets course by ID"

    type Types::Course::CourseType, null: false

    argument :id, ID, required: true
    
    def resolve(id:)
      Course.find(id)
    rescue ActiveRecord::RecordNotFound => e 
      GraphQL::ExecutionError.new(e.message)
    end
  end
end