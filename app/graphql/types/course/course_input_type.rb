# frozen_string_literal: true

class Types::Course::CourseInputType < Types::BaseInputObject
  argument :name, String, required: true
  argument :description, String, required: false
  argument :chapters, [Types::Chapter::ChapterInputType], required: false
end
