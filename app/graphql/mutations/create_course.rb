# frozen_string_literal: true

module Mutations
  class CreateCourse < BaseMutation
    description "Creates a course with chapters and units"

    field :course, Types::Course::CourseType, null: true

    argument :input, Types::Course::CourseInputType, required: true

    def resolve(input:)
      course = Course.build_course(input.to_h)
      { course: course } 
    rescue *EXCEPTIONS => e
      GraphQL::ExecutionError.new(e.summary)
    end
  end
end
