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
class Chapter < ApplicationRecord
  belongs_to :course

  has_many :units, dependent: :destroy

  validates :name, presence: true

  def self.build_chapter(params)
    chapter = Chapter.build(
      name: params[:name],
      course_id: params[:course_id],
      sort_key: params[:sort_key],
    ) 
    chapter.build_with_units(params[:units]) if params[:units]
    chapter.save!
    chapter
  end

  def build_with_units(units_params) 
    idx = 1
    units_params&.each do |params|
      unit = units.build(params)
      unit.sort_key = idx
      idx += 1
    end 
  end

  def self.update_chapter_by(id, params)
    chapter = Chapter.includes(:units).find(id)
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
        unit = units.find { |u| u.id == params[:id].to_i }
        unit&.assign_attributes(params)
      else
        unit = units.build(params)
        unit.sort_key = size + 1 
        size += 1
      end
    end
  end
end
