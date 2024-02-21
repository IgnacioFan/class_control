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
require 'rails_helper'

RSpec.describe Unit, type: :model do
  it { is_expected.to be_mongoid_document }

  describe "#validates" do
    let!(:course) { create(:course) }
    let!(:chapter) { create(:chapter, course: course) }

    context "when success" do
      it { expect(chapter.units.create(name: "test", content: "test")).to be_valid }
    end

    context "when failure" do
      context "without name" do
        it { expect(chapter.units.create(name: "", content: "test")).not_to be_valid }
      end

      context "without content" do
        it { expect(chapter.units.create(name: "test", content: "")).not_to be_valid }
      end
    end
  end

  describe "associations" do
    it { is_expected.to be_embedded_in(:chapter) }
  end
end
