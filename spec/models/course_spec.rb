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
  it { is_expected.to be_mongoid_document }

  describe "#validates" do
    context "with name" do
      subject { Course.create(name: "test") }

      it { is_expected.to be_valid }
    end

    context "with no name" do
      subject { Course.create(name: "") }

      it { is_expected.not_to be_valid }
    end
  end

  describe "associations" do
    it { is_expected.to embed_many(:chapters) }
  end

  describe ".build_course" do
    subject { Course.build_course(params) }

    context "when success" do 
      context "when creates course and chapters" do
        let(:params) {
          {
            name: "New Course",
            chapters: [
              { name: "Chapter A" },
              { name: "Chapter B" },
              { name: "Chapter C" }
            ]
          }
        }

        it_behaves_like "build course"
      end

      context "when creates course, chapters, and units" do
        let(:params) {
          {
            name: "New Course",
            chapters: [
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
        }

        it_behaves_like "build course"
      end
    end
  end

  describe ".update_course_by" do
    let!(:course) { create(:course, name: "JavaScript")}
    let!(:chapter) { create(:chapter, course: course, name: "Draft", sort_key: 1)}
    let!(:unit) { create(:unit, chapter: chapter, name: "Draft", sort_key: 1)}
    
    subject { Course.update_course_by(course.id, params) }

    context "when success" do
      context "when updates course only" do
        let(:params) { 
          {
            name: "Ruby on Rails",
            description: "test"
          }
        }

        it_behaves_like "update course" 
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

        it_behaves_like "update course"
      end

      context "when updates course and adds new chapters" do
        let(:params) { 
          {
            name: "Ruby on Rails",
            description: "test",
            chapters: [
              { name: "Chapter B" }
            ]
          }
        }

        it_behaves_like "update course" 

        it "adds new chapter" do
          chapter = subject.chapters.last
          expect(chapter.changed?).to eq(false)
          expect(chapter.sort_key).to eq(2)
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

        it_behaves_like "update course" 
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
        
        it_behaves_like "update course"

        it "adds new unit" do
          unit = subject.chapters.first.units.last
          expect(unit.sort_key).to eq(2)
        end
      end
    end
  end
end
