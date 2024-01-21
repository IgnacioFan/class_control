# frozen_string_literal: true

module Mutations
  class DeleteCourse < BaseMutation 
    description "Deletes a course by id"
    
    field :course, Types::Course::CourseType, null: true
  
    argument :id, ID, required: true
  
    def resolve(id:)
      course = Course.find(id)
      { course: course } if course.destroy
    rescue *EXCEPTIONS => e 
      GraphQL::ExecutionError.new(e.message)
    end
  end
end

