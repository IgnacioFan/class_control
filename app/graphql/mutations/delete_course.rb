# frozen_string_literal: true

module Mutations
  class DeleteCourse < BaseMutation 
    description "Deletes a course"
    
    field :course, Types::Course::CourseType, null: true
  
    argument :id, ID, required: true
  
    def resolve(id:)
      course = Course.find(id)
      if course.destroy
        { course: course }
      else
        GraphQL::ExecutionError.new("failed to delete the course")
      end 
    rescue *EXCEPTIONS => e 
      GraphQL::ExecutionError.new(e.summary)
    end
  end
end

