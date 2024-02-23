# frozen_string_literal: true

module Mutations
  class ReorderUnits < BaseMutation 
    description "Reorders units"

    field :chapter, Types::Chapter::ChapterType, null: true
  
    argument :course_id, ID, required: true
    argument :chapter_id, ID, required: true
    argument :order, [Integer], required: true
  
    def resolve(course_id:, chapter_id:, order:)
      course = Course.find(course_id)
      chapter = course.chapters.find(chapter_id)
      order.each_with_index do |id, index|
        unit = chapter.units.find(id)
        unit.sort_key = index + 1
      end
      { chapter: chapter } if chapter.save!
    rescue *EXCEPTIONS => e 
      GraphQL::ExecutionError.new(e.summary)
    end
  end
end
