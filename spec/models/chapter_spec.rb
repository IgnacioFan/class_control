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

  describe ".build_chapter" do
    let!(:course) { create(:course) }
    let!(:chapter) { create(:chapter, course: course) }

    context "when success" do 
      let(:params) {
        {
          name: "New Chapter",
          course_id: course.id,
          sort_key: 2,
          units: units
        }
      }

      context "params without units" do
        let(:units) { nil }

        it "increases the number of course and chapters" do
          expect{ Chapter.build_chapter(params) }.to \
            change(Chapter, :count).from(1).to(2).and \
            change(Unit, :count).by(0)
        end
      end

      context "params with units" do
        let(:units) {
          [
            {
              name: "Unit 1",
              description: "",
              content: "Hello World"
            }
          ]
        }

        it "increases the number of course and chapters" do
          expect{ Chapter.build_chapter(params) }.to \
            change(Chapter, :count).from(1).to(2).and \
            change(Unit, :count).from(0).to(1)
        end
      end
    end

    context "when failure" do
      context "params with invalid course_id" do
        let(:params) {
          {
            name: "New Chapter",
            course_id: course.id + 1,
            sort_key: 2,
          }
        }
        it { 
          expect{ Chapter.build_chapter(params) }.to \
            raise_error(ActiveRecord::RecordInvalid, \
            /Validation failed: Course must exist/) 
        } 
      end
    end
  end

  describe ".update_chapter_by" do
    let!(:course) { create(:course)}
    let!(:chapter) { create(:chapter, course: course, name: "Draft", sort_key: 1)}
    let!(:unit) { create(:unit, chapter: chapter, name: "Draft", sort_key: 1)}

    context "when success" do
      context "when updates chapter only" do
        let(:params) {
          {
            name: "Chapter A",
          }
        }

        it "returns chapter" do
          expect(Chapter.update_chapter_by(chapter.id, params)).to \
            have_attributes(
              name: "Chapter A",
              sort_key: 1
            )
        end  
      end

      context "when updates chapter and units" do
        let(:params) {
          {
            name: "Chapter A",
            units: [
              { 
                id: unit.id,
                name: "Unit A-1",
                description: "",
                content: "Hello World",
              }
            ]
          }
        }

        it "returns chapter" do
          expect(Chapter.update_chapter_by(chapter.id, params)).to \
            have_attributes(
              name: "Chapter A",
              sort_key: 1
            )
        end

        it "unit updated" do
          Chapter.update_chapter_by(chapter.id, params)
          expect(unit.reload).to \
            have_attributes(
              name: "Unit A-1",
              description: "",
              content: "Hello World",
              sort_key: 1
            )
        end
      end

      context "when updates chapter and addes new units" do
        let(:params) {
          {
            name: "Chapter A",
            units: [
              { 
                name: "Unit A-2",
                description: "",
                content: "Test",
              }
            ]
          }
        }

        it "returns chapter" do
          expect(Chapter.update_chapter_by(chapter.id, params)).to \
            have_attributes(
              name: "Chapter A",
              sort_key: 1
            )
        end

        it "new unit added" do
          Chapter.update_chapter_by(chapter.id, params)
          expect(chapter.units.last).to \
            have_attributes(
              name: "Unit A-2",
              description: "",
              content: "Test",
              sort_key: 2
            )
        end
      end
    end
  end
end
