require "rails_helper"

RSpec.describe "Mutations::ReorderChapters" do
  def perform(**args)
    Mutations::ReorderChapters.new(object: nil, field: nil, context: { current_user: current_user }).resolve(**args)
  end

  let(:current_user) { "user1" }
  let!(:course) { create(:course)}
  let!(:chapter1) { create(:chapter, course: course, sort_key: 1)}
  let!(:chapter2) { create(:chapter, course: course, sort_key: 2)}
  let!(:chapter3) { create(:chapter, course: course, sort_key: 3)}
  let(:order) { [chapter3.id, chapter2.id, chapter1.id] }

  after { Course.collection.drop }

  context "when success" do
    it "returns course" do
      perform(course_id: course.id, order: order) 
      expect(chapter1.reload.sort_key).to eq(3)
      expect(chapter2.reload.sort_key).to eq(2)
      expect(chapter3.reload.sort_key).to eq(1)
    end
  end

  context "when failures" do
    context "when current_user not found" do
      let(:current_user) {}
      it "returns error message" do
        data = perform(course_id: "", order: order) 
        expect(data.class).to eq(GraphQL::ExecutionError)
        expect(data.message).to include("permission denied")
      end
    end

    context "when id not found" do
      it "returns error message" do
        data = perform(course_id: "non_existent_id", order: order) 
        expect(data.class).to eq(GraphQL::ExecutionError)
        expect(data.message).to include("non_existent_id")
      end
    end
  end
end
