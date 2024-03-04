# frozen_string_literal: true

module Mutations
  class CreateCourse < BaseMutation
    description "Creates a new course, including chapters and units"

    field :course, Types::Course::CourseType, null: true

    argument :input, Types::Course::CourseInputType, required: true

    def resolve(input:)
      permission_denied!

      course = Course.build_course(context[:current_user], input.to_h)
      { course: course } 
    rescue *EXCEPTIONS => e
      GraphQL::ExecutionError.new(e)
    end
  end
end
