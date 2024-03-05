require "rails_helper"

RSpec.describe "Resolvers::ChapterById" do
  def perform(**args)
    Resolvers::ChapterById.new(object: nil, field: nil, context: { current_user: current_user }).resolve(**args)
  end

  let(:current_user) { "user1" }
  let!(:course) { create(:course) }
  let!(:chapter) { create(:chapter, course: course, name: "test") }

  after { Course.collection.drop }

  context "when success" do      
    it "returns a chapter" do
      get_chapter = perform(course_id: course.id, chapter_id: chapter.id) 
      expect(get_chapter.class).to eq(Chapter)
      expect(get_chapter.name).to eq("test")
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
        data = perform(course_id: course.id, chapter_id: "non_existent_id") 
        expect(data.class).to eq(GraphQL::ExecutionError)
        expect(data.message).to include("non_existent_id")
      end
    end
  end
end
