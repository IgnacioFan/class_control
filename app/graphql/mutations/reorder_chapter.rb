# frozen_string_literal: true

module Mutations
  class ReorderChapter < BaseMutation 
    description "Reorders chapters by courseId"

    field :course, Types::Course::CourseType, null: true
  
    argument :id, ID, required: true
    argument :order, [Integer], required: true
  
    def resolve(id:, order: )
      # check if the numb of input values is equal to the num of course.chapters 
      # update all chapters' sort_key 
      course = Course.includes(:chapters).find(id)
      ActiveRecord::Base.transaction do 
        order.each_with_index do |id, index|
          chapter = course.chapters.find { |c| c.id == id }
          chapter.sort_key = index + 1
          chapter.save!
        end
      end
      { course: course }
    rescue ActiveRecord::RecordNotFound => e 
      GraphQL::ExecutionError.new(e.message)
    end
  end
end
