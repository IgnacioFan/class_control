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
require 'rails_helper'

RSpec.describe Course, type: :model do
  let(:course) { build(:course, name: name) }

  describe "#validates" do
    let(:name) { "test" }

    subject { course.save }

    context "with name" do
      it { is_expected.to eq(true) }
    end

    context "without name" do
      let(:name) { "" }
      it { is_expected.to eq(false) }
    end
  end
end
