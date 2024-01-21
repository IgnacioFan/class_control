# == Schema Information
#
# Table name: courses
#
#  id          :integer          not null, primary key
#  deleted_at  :datetime
#  description :text
#  name        :string(255)      not null
#  created_at  :datetime
#  updated_at  :datetime
#
class Course < ApplicationRecord
  has_many :chapters, dependent: :destroy

  validates :name, presence: true
  # validates :lecturer, presence: true

  def self.build_course(params)
    course = Course.build(
      name: params[:name],
      description: params[:description] || ""
    )      
    
    course.build_with_chapters(params[:chapters]) if params[:chapters]
    course.save!
    course
  end

  def build_with_chapters(chapter_params) 
    idx = 1
    chapter_params&.each do |params|
      chapter = chapters.build(
        name: params[:name],
        sort_key: idx,
      ) 
      chapter.build_with_units(params[:units]) if params[:units]
      idx += 1
    end 
  end

  def self.update_course_by(id, params)
    course = Course.includes(:chapters => :units).find(id)
    course.assign_attributes(
      name: params[:name],
      description: params[:description] || ""
    )
    course.update_with_chapters(params[:chapters]) if params[:chapters]
    course.save!
    course
  end

  def update_with_chapters(chapter_params)
    size = chapter.size
    chapter_params&.each do |params|
      chapter = if params[:id].present?
        obj = chapter.find { |ch| ch.id == params[:id].to_i }
        obj&.assign_attributes(params)
      else
        obj = chapters.build(params)
        obj.sort_key = size + 1 
        size += 1
      end

      chapter.build_with_units(params[:units]) if params[:units]
    end
  end
end
