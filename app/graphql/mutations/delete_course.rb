# frozen_string_literal: true

module Mutations
  class DeleteCourse < BaseMutation 
    description "Deletes a course by ID"
    
    field :course, Types::Course::CourseType, null: true
  
    argument :id, ID, required: true
  
    def resolve(id: )
      course = Course.find(id)
      if course.destroy
        { course: course }
      end
    rescue ActiveRecord::RecordNotFound => e 
      GraphQL::ExecutionError.new(e.message)
    end
  end
end

