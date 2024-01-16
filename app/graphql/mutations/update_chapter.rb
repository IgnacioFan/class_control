# # frozen_string_literal: true

module Mutations
  class UpdateChapter < BaseMutation 
    description "Updates a chapter by chpater ID"
    
    field :chapter, Types::Chapter::ChapterType, null: true
  
    argument :id, ID, required: true
    argument :input, Types::Chapter::ChapterInputType, required: true
  
    def resolve(id:, input: )
      chapter = Chapter.includes(:units).find(id)
      chapter.assign_attributes(input.to_h.except(:units))

      input.to_h[:units]&.each do |unit_attrs|
        if unit_attrs[:id].present?
          unit = chapter.units.find { |u| u.id == unit_attrs[:id].to_i }
          unit&.update(unit_attrs)
        end
      end

      { chapter: chapter } if chapter.save!
    rescue ActiveRecord::RecordNotFound => e 
      GraphQL::ExecutionError.new(e.message)
    end
  end
end
