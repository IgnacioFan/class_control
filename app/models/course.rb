# == Schema Information
#
# Table name: courses
#
#  id          :bigint           not null, primary key
#  description :text
#  lecturer    :string           not null
#  name        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
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
end
