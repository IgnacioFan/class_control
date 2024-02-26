# frozen_string_literal: true

module Mutations
  class ReorderChapters < BaseMutation 
    description "Reorders chapters"

    field :course, Types::Course::CourseType, null: true
  
    argument :course_id, ID, required: true
    argument :order, [ID], required: true
  
    def resolve(course_id:, order:)
      course = Course.find(course_id)
      order.each_with_index do |id, index|
        chapter = course.chapters.find(id)
        chapter.sort_key = index + 1
      end
      { course: course } if course.save!
    rescue *EXCEPTIONS => e 
      GraphQL::ExecutionError.new(e.summary)
    end
  end
end
