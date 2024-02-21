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
  it { is_expected.to be_mongoid_document }

  describe "#validates" do
    let!(:course) { create(:course)}

    context "with name" do
      subject { course.chapters.create(name: "test") }

      it { is_expected.to be_valid }
    end

    context "without name" do
      subject { course.chapters.create(name: "") }

      it { is_expected.not_to be_valid }
    end
  end

  describe "associations" do
    it { is_expected.to be_embedded_in(:course) }
    it { is_expected.to embed_many(:units) }
  end

  describe ".build_chapter" do
    let!(:course) { create(:course) }
    let(:course_id) { course.id }
    let!(:chapter) { create(:chapter, course: course) }

    subject { Chapter.build_chapter(course_id, params) }

    context "when success" do 
      context "when creates chapters" do
        let(:params) {
          {
            name: "New Chapter"
          }
        }

        it_behaves_like "build chapter"
      end

      context "when creates chapters and units" do
        let(:params) {
          {
            name: "New Chapter",
            units: [
              {
                name: "Unit 1",
                description: "",
                content: "Hello World"
              },
              {
                name: "Unit 2",
                description: "",
                content: "Hello World"
              }
            ]
          }
        }

        it_behaves_like "build chapter"
      end
    end

    context "when failure" do
      context "when the course not found" do
        let(:course_id) { "non_existent_id" }
        let(:params) {
          {
            name: "New Chapter"
          }
        }

        it { is_expected.to raise_error(Mongoid::Errors::DocumentNotFound) }
      end
    end
  end

  describe ".update_chapter_by" do
    let!(:course) { create(:course)}
    let(:course_id) { course.id }
    let!(:chapter) { create(:chapter, course: course, name: "Draft", sort_key: 1)}
    let!(:unit) { create(:unit, chapter: chapter, name: "Draft", sort_key: 1)}

    subject { Chapter.update_chapter_by(course_id, params) }

    context "when success" do
      context "when updates a chapter" do
        let(:params) {
          {
            id: chapter.id,
            name: "Chapter A",
          }
        }
        
        it_behaves_like "update chapter" 
      end

      context "when updates a chapter and units" do
        let(:params) {
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
        }

        it_behaves_like "update chapter" 
      end

      context "when updates a chapter and addes a unit" do
        let(:params) {
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
        }

        it_behaves_like "update chapter"
      end
    end

    context "when failure" do
      context "when the course not found" do
        let(:course_id) { "non_existent_id" }
        let(:params) {
          {
            id: chapter.id,  
            name: "New Chapter"
          }
        }

        it { is_expected.to raise_error(Mongoid::Errors::DocumentNotFound) }
      end

      context "when the chapter not found" do
        let(:params) {
          {
            id: "non_existent_id",  
            name: "New Chapter"
          }
        }

        it { is_expected.to raise_error(Mongoid::Errors::DocumentNotFound) }
      end
    end
  end
end
