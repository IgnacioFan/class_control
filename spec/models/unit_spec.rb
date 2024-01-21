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
  let(:unit) { build(:unit, name: name, content: content) }

  describe "#validates" do
    let(:name) { "test" }
    let(:content) { "test" }

    subject { unit.save }

    context "with name" do
      it { is_expected.to eq(true) }
    end

    context "without name" do
      let(:name) { "" }
      it { is_expected.to eq(false) }
    end

    context "with content" do
      it { is_expected.to eq(true) }
    end

    context "without content" do
      let(:content) { "" }
      it { is_expected.to eq(false) }
    end
  end
end
