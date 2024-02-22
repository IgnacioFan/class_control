# == Schema Information
#
# Table name: units
#
#  id          :integer          not null, primary key
#  content     :text             not null
#  deleted_at  :datetime
#  description :text
#  name        :string(255)      not null
#  sort_key    :integer          not null
#  created_at  :datetime
#  updated_at  :datetime
#  chapter_id  :integer
#
# Foreign Keys
#
#  units_chapter_id_fkey  (chapter_id => chapters.id)
#
class Unit
  include Mongoid::Document

  field :name, type: String
  field :content, type: String
  field :description, type: String
  field :sort_key, type: Integer

  embedded_in :chapter

  validates :name, presence: true
  validates :content, presence: true

  def self.build_unit(course_id, chapter_id, params)
    course = Course.find(course_id)
    chapter = course.chapters.find(chapter_id)
    chapter.units.create!(
      name: params[:name],
      description: params[:description],
      content: params[:content],
      sort_key: chapter.units.size + 1,
    )
  end

  def self.update_unit_by(id, params)
    unit = Unit.find(id)
    unit.update!(params)
    unit
  end
end
