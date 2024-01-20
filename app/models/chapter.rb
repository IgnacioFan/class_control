# == Schema Information
#
# Table name: chapters
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  sort_key   :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  course_id  :bigint           not null
#
# Indexes
#
#  index_chapters_on_course_id  (course_id)
#
# Foreign Keys
#
#  fk_rails_...  (course_id => courses.id)
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
end
