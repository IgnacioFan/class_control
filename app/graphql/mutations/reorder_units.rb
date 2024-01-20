# frozen_string_literal: true

module Mutations
  class ReorderUnits < BaseMutation 
    description "Reorders units by chapter ID"

    field :chapter, Types::Chapter::ChapterType, null: true
  
    argument :id, ID, required: true
    argument :order, [Integer], required: true
  
    def resolve(id:, order: )
      # check if the num of input values is equal to the num of chapter.units 
      # update all unit's sort_key 
      chapter = Chapter.includes(:units).find(id)
      ActiveRecord::Base.transaction do 
        order.each_with_index do |id, index|
          unit = chapter.units.find { |c| c.id == id }
          unit.sort_key = index + 1
          unit.save!
        end
      end
      { chapter: chapter }
    rescue ActiveRecord::RecordNotFound => e 
      GraphQL::ExecutionError.new(e.message)
    end
  end
end
