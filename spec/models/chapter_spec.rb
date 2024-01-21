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
require 'rails_helper'

RSpec.describe Chapter, type: :model do
  let(:chapter) { build(:chapter, name: name) }

  describe "#validates" do
    subject { chapter.save }

    context "with name" do
      let(:name) { "test" }
      it { is_expected.to eq(true) }
    end

    context "without name" do
      let(:name) { "" }
      it { is_expected.to eq(false) }
    end
  end
end
