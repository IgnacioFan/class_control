# frozen_string_literal: true

module Mutations
  class CreateCourse < BaseMutation
    description "Creates a course"

    field :course, Types::Course::CourseType, null: true

    argument :input, Types::Course::CourseInputType, required: true

    def resolve(input:)
      course = Course.build_course(input.to_h)
      { course: course } 
    rescue ActiveRecord::RecordInvalid => e
      GraphQL::ExecutionError.new("Invalid input: #{e.record.errors.full_messages.join(', ')}")
    end
  end
end
