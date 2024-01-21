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
class Unit < ApplicationRecord
  belongs_to :chapter

  validates :name, presence: true
  validates :content, presence: true

  def self.build_unit(params)
    unit = Unit.build(
      name: params[:name],
      description: params[:description],
      content: params[:content],
      chapter_id: params[:chapter_id],
      sort_key: params[:sort_key],
    ) 
    unit.save!
    unit
  end

  def self.update_unit_by(id, params)
    unit = Unit.find(id)
    unit.update!(params)
    unit
  end
end
