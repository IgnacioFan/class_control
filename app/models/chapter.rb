# == Schema Information
#
# Table name: chapters
#
#  id         :integer          not null, primary key
#  deleted_at :datetime
#  name       :string(255)      not null
#  sort_key   :integer          not null
#  created_at :datetime
#  updated_at :datetime
#  course_id  :integer
#
# Foreign Keys
#
#  chapters_course_id_fkey  (course_id => courses.id)
#
class Chapter 
  include Mongoid::Document

  field :name, type: String
  field :sort_key, type: Integer

  embedded_in :course
  embeds_many :units

  validates :name, presence: true

  def self.build_chapter(course_id, params)
    course = Course.find(course_id)
    chapter = course.chapters.build(
      name: params[:name],
      sort_key: course.chapters.size + 1,
    ) 
    chapter.build_with_units(params[:units]) if params[:units]
    chapter.save!
    chapter
  end

  def build_with_units(units_params) 
    idx = 1
    units_params&.each do |params|
      unit = units.new(params)
      unit.sort_key = idx
      unit.save
      idx += 1
    end 
  end

  def self.update_chapter_by(course_id, params)
    course = Course.find(course_id)
    chapter = course.chapters.find(params[:id])
    chapter.assign_attributes(
      name: params[:name],
    )
    chapter.update_with_units(params[:units]) if params[:units]
    chapter.save!
    chapter
  end

  def update_with_units(units_params)
    size = units.size
    units_params&.each do |params|
      if params[:id].present?
        unit = units.find(params[:id])
        unit&.update(params)
      else
        units.create!(
          sort_key: size + 1,
          **params
        )
        size += 1
      end
    end
  end
end
