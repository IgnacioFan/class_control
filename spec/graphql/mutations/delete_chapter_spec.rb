require "rails_helper"

RSpec.describe "Mutations::DeleteChapter" do
  def perform(**args)
    Mutations::DeleteChapter.new(object: nil, field: nil, context: { current_user: current_user }).resolve(**args)
  end

  let(:current_user) { "user1" }
  let!(:course) { create(:course) }
  let!(:chapter) { create(:chapter, course: course) }
  let!(:unit) { create(:unit, chapter: chapter) }

  subject { perform(course_id: course.id, chapter_id: chapter.id) }

  after { Course.collection.drop }

  context "when success" do
    it "returns chapter" do
      delete_chapter = subject[:chapter]
      expect(delete_chapter.class).to eq(Chapter)
      expect(delete_chapter.id).to eq(chapter.id)
    end

    it "removes chapter" do
      subject
      expect(course.reload.chapters).to eq([])
    end
  end

  context "when failure" do
    context "when current_user not found" do
      let(:current_user) {}
      it "returns error message" do
        data = perform(course_id: "", chapter_id: "") 
        expect(data.class).to eq(GraphQL::ExecutionError)
        expect(data.message).to include("permission denied")
      end
    end

    context "when id not found" do
      it "returns error message" do
        data = perform(course_id: course.id, chapter_id: "non_exsistent_id") 
        expect(data.class).to eq(GraphQL::ExecutionError)
        expect(data.message).to include("non_exsistent_id")
      end
    end
  end
end
