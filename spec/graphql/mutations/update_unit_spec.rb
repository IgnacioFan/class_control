require "rails_helper"

RSpec.describe "Mutations::UpdateUnit" do
  def perform(**args)
    Mutations::UpdateUnit.new(object: nil, field: nil, context: { current_user: current_user }).resolve(**args)
  end

  let(:current_user) { "user1" }
  let!(:course) { create(:course) }
  let!(:chapter) { create(:chapter, course: course) }
  let!(:unit) { create(:unit, chapter: chapter) }
  let(:params) {
    {
      id: unit.id,
      name: "Unit updated",
      content: "Content updated"
    }
  }

  subject { perform(course_id: course.id, chapter_id: chapter.id, input: params)[:unit] }

  context "when success" do
    it "returns unit" do
      updated_unit = subject
      expect(updated_unit.id).to eq(unit.id)
      expect(updated_unit.name).to eq("Unit updated")
      expect(updated_unit.content).to eq("Content updated")
    end
  end

  context "when failure" do
    context "when current_user not found" do
      let(:current_user) {}
      it "returns error message" do
        data = perform(course_id: "", chapter_id: "", input: params) 
        expect(data.class).to eq(GraphQL::ExecutionError)
        expect(data.message).to include("permission denied")
      end
    end

    context "when id not found" do
      it "returns error message" do
        data = perform(course_id: course.id, chapter_id: "non_existent_id", input: params) 
        expect(data.class).to eq(GraphQL::ExecutionError)
        expect(data.message).to include("non_existent_id")
      end
    end
  end
end
