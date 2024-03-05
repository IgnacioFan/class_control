# frozen_string_literal: true

module Mutations
  class UpdateCourse < BaseMutation 
    description "Updates a course, including chapters and units"
    
    field :course, Types::Course::CourseType, null: true
  
    argument :id, ID, required: true
    argument :input, Types::Course::CourseInputType, required: true
  
    def resolve(id:, input:)
      permission_denied!
      
      course = Course.update_course_by(id, input.to_h)
      { course: course }
    rescue *EXCEPTIONS => e 
      GraphQL::ExecutionError.new(e)
    end
  end
end
