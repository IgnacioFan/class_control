# frozen_string_literal: true

module Mutations
  class CreateCourse < BaseMutation
    field :course, Types::Course::CourseType, null: true

    argument :input, Types::Course::CourseInputType, required: true

    def resolve(input:)
      course = CourseFactory.new(input.to_h).execute

      { course: course }
    rescue ActiveRecord::RecordInvalid => e
      GraphQL::ExecutionError.new("Invalid input: #{e.record.errors.full_messages.join(', ')}")
    end
  end
end
