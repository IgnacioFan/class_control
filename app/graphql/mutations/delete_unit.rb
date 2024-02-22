# frozen_string_literal: true

module Mutations
  class DeleteUnit < BaseMutation 
    description "Deletes a unit"
    
    field :unit, Types::Unit::UnitType, null: true
  
    argument :course_id, ID, required: true
    argument :chapter_id, ID, required: true
    argument :unit_id, ID, required: true
  
    def resolve(course_id:, chapter_id:, unit_id:)
      course = Course.find(course_id)
      chapter = course.chapters.find(chapter_id)
      unit = chapter.units.find(unit_id)
      if unit.destroy
        { unit: unit } 
      else
        GraphQL::ExecutionError.new("failed to delete the unit")
      end 
    rescue *EXCEPTIONS => e 
      GraphQL::ExecutionError.new(e.summary)
    end
  end
end

