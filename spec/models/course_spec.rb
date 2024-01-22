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

  describe ".build_course" do
    context "when success" do 
      let(:params) {
        {
          name: "New Course",
          chapters: chapters
        }
      }

      context "params with chapters" do
        let(:chapters) {
          [
            {
              name: "Chapter A"
            },
            {
              name: "Chapter B"
            },
            {
              name: "Chapter C"
            }
          ]
        }

        it "increases the number of course and chapters" do
          expect{ Course.build_course(params) }.to \
            change(Course, :count).from(0).to(1).and \
            change(Chapter, :count).from(0).to(3).and \
            change(Unit, :count).by(0)
        end
      end

      context "params with chapters and units" do
        let(:chapters) {
          [
            {
              name: "Chapter A",
              units: [
                {
                  name: "Unit 1",
                  description: "",
                  content: "Hello World"
                }
              ]
            },
            {
              name: "Chapter B",
              units: [
                {
                  name: "Unit 2",
                  description: "",
                  content: "Hello World"
                }
              ]
            }
          ]
        }

        it "increases the number of course, chapters and units" do
          expect{ Course.build_course(params) }.to \
            change(Course, :count).from(0).to(1).and \
            change(Chapter, :count).from(0).to(2).and \
            change(Unit, :count).from(0).to(2)
        end
      end
    end
  end

  describe ".update_course_by" do
    let!(:course) { create(:course, name: "JavaScript")}
    let!(:chapter) { create(:chapter, course: course, name: "Draft", sort_key: 1)}
    let!(:unit) { create(:unit, chapter: chapter, name: "Draft", sort_key: 1)}

    context "when success" do
      context "when updates course only" do
        let(:params) {
          {
            name: "Ruby on Rails",
            description: "test"
          }
        }

        it "returns course" do
          expect(Course.update_course_by(course.id, params)).to \
            have_attributes(
              name: "Ruby on Rails",
              description: "test"
            )
        end  
      end

      context "when updates course and chapters" do
        let(:params) {
          {
            name: "Ruby on Rails",
            description: "test",
            chapters: [
              {
                id: chapter.id,
                name: "Chapter A"
              }
            ]
          }
        }

        it "returns course" do
          expect(Course.update_course_by(course.id, params)).to \
            have_attributes(
              name: "Ruby on Rails",
              description: "test"
            )
        end 

        it "chapter updated" do
          Course.update_course_by(course.id, params)
          expect(chapter.reload).to \
            have_attributes(
              name: "Chapter A",
              sort_key: 1
            )
        end 
      end

      context "when updates course and adds new chapters" do
        let(:params) {
          {
            name: "Ruby on Rails",
            description: "test",
            chapters: [
              {
                name: "Chapter B"
              }
            ]
          }
        }

        it "returns course" do
          expect(Course.update_course_by(course.id, params)).to \
            have_attributes(
              name: "Ruby on Rails",
              description: "test"
            )
        end 

        it "new chapter added" do
          Course.update_course_by(course.id, params)
          expect(course.chapters.last).to \
            have_attributes(
              name: "Chapter B",
              sort_key: 2
            )
        end
      end

      context "when updates course, chapters, and units" do
        let(:params) {
          {
            name: "Ruby on Rails",
            description: "test",
            chapters: [
              {
                id: chapter.id,
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
            ]
          }
        }

        it "returns course" do
          expect(Course.update_course_by(course.id, params)).to \
            have_attributes(
              name: "Ruby on Rails",
              description: "test"
            )
        end 

        it "chapter updated" do
          Course.update_course_by(course.id, params)
          expect(chapter.reload).to \
            have_attributes(
              name: "Chapter A",
              sort_key: 1
            )
        end

        it "unit updated" do
          Course.update_course_by(course.id, params)
          expect(unit.reload).to \
            have_attributes(
              name: "Unit A-1",
              description: "",
              content: "Hello World",
              sort_key: 1
            )
        end
      end

      context "when updates course, chapters, and addes new units" do
        let(:params) {
          {
            name: "Ruby on Rails",
            description: "test",
            chapters: [
              {
                id: chapter.id,
                name: "Chapter A",
                units: [
                  { 
                    name: "Unit A-2",
                    description: "",
                    content: "Test",
                  }
                ]
              }
            ]
          }
        }

        it "returns course" do
          expect(Course.update_course_by(course.id, params)).to \
            have_attributes(
              name: "Ruby on Rails",
              description: "test"
            )
        end 

        it "chapter updated" do
          Course.update_course_by(course.id, params)
          expect(chapter.reload).to \
            have_attributes(
              name: "Chapter A",
              sort_key: 1
            )
        end

        it "new unit added" do
          Course.update_course_by(course.id, params)
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
