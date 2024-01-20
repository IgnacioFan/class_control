# frozen_string_literal: true

module Resolvers
  class Courses < BaseResolver
    description "Gets courses"

    type [Types::Course::CourseType], null: false

    # argument :limit, Integer, required: false
    
    def resolve
      # TODO: fetch course with limit and offset
      Course.all
    end
  end
end
