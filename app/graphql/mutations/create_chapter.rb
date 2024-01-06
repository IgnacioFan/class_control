# frozen_string_literal: true

module Mutations
  class CreateChapter < BaseMutation
    description "create a chapter by course id"

    field :chapter, Types::Chapter::ChapterType, null: true
    
    argument :id, ID, required: true
    argument :input, Types::Chapter::ChapterInputType, required: true

    # TODO: refactor the logic of creating chapter and units
    def resolve(id:, input:)
      course = Course.find(id)
      
      chapter = course.chapters.build(input.to_h.except(:units))
      chapter.sort_key = course.chapters.size 

      input.to_h[:units]&.each { |unit_hash|  
        unit = chapter.units.build(unit_hash)
        unit.sort_key = chapter.units.size
      }
      
      { chapter: chapter } if course.save!
    rescue ActiveRecord::RecordInvalid => e
      GraphQL::ExecutionError.new("Invalid input: #{e.record.errors.full_messages.join(', ')}")
    end
  end
end
