# frozen_string_literal: true

module Resolvers
  class UnitById < BaseResolver
    description "Gets a unit"

    type Types::Unit::UnitType, null: false

    argument :course_id, ID, required: true
    argument :chapter_id, ID, required: true
    argument :unit_id, ID, required: true
    
    def resolve(course_id:, chapter_id:, unit_id:)
      course = Course.find(course_id)
      chapter = course.chapters.find(chapter_id)
      chapter.units.find(unit_id)
    rescue *EXCEPTIONS => e 
      GraphQL::ExecutionError.new(e.summary)
    end
  end
end
