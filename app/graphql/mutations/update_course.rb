# frozen_string_literal: true

module Mutations
  class UpdateCourse < BaseMutation 
    description "Updates a course"
    
    field :course, Types::Course::CourseType, null: true
  
    argument :id, ID, required: true
    argument :input, Types::Course::CourseInputType, required: true
  
    def resolve(id:, input:)
      course = Course.update_course_by(id, input.to_h)
      { course: course }
    rescue *EXCEPTIONS => e 
      GraphQL::ExecutionError.new(e.summary)
    end
  end
end
