require "rails_helper"

RSpec.describe "Mutations::ReorderUnits" do
  def perform(**args)
    Mutations::ReorderUnits.new(object: nil, field: nil, context: { current_user: current_user }).resolve(**args)
  end

  let(:current_user) { "user1" }
  let!(:course) { create(:course)}
  let!(:chapter) { create(:chapter, course: course)}
  let!(:unit1) { create(:unit, chapter: chapter, sort_key: 1)}
  let!(:unit2) { create(:unit, chapter: chapter, sort_key: 2)}
  let!(:unit3) { create(:unit, chapter: chapter, sort_key: 3)}
  
  let(:order) { [unit3.id, unit2.id, unit1.id] }

  after { Course.collection.drop }

  context "when success" do
    it "updates the sort_key of the units" do
      perform(course_id: course.id, chapter_id: chapter.id, order: order) 
      expect(unit1.reload.sort_key).to eq(3)
      expect(unit2.reload.sort_key).to eq(2)
      expect(unit3.reload.sort_key).to eq(1)
    end
  end

  context "when failures" do
    context "when current_user not found" do
      let(:current_user) {}
      it "returns error message" do
        data = perform(course_id: "", chapter_id: "", order: order) 
        expect(data.class).to eq(GraphQL::ExecutionError)
        expect(data.message).to include("permission denied")
      end
    end

    context "when id not found" do
      it "returns error message" do
        data = perform(course_id: course.id, chapter_id: "non_existent_id", order: order) 
        expect(data.class).to eq(GraphQL::ExecutionError)
        expect(data.message).to include("non_existent_id")
      end
    end
  end
end
