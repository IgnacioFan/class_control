require "rails_helper"

RSpec.describe "Resolvers::UnitById" do
  def perform(**args)
    Resolvers::UnitById.new(object: nil, field: nil, context: { current_user: current_user }).resolve(**args)
  end

  let(:current_user) { "user1" }
  let!(:course) { create(:course) }
  let!(:chapter) { create(:chapter, course: course) }
  let!(:unit) { create(:unit, chapter: chapter, name: "test") }

  after { Course.collection.drop }

  context "when success" do      
    it "returns a unit" do
      get_unit = perform(course_id: course.id, chapter_id: chapter.id, unit_id: unit.id) 
      expect(get_unit.class).to eq(Unit)
      expect(get_unit.name).to eq("test")
    end
  end

  context "when failure" do
    context "when current_user not found" do
      let(:current_user) {}
      it "returns error message" do
        data = perform(course_id: "", chapter_id: "", unit_id: "") 
        expect(data.class).to eq(GraphQL::ExecutionError)
        expect(data.message).to include("permission denied")
      end
    end

    context "when id not found" do
      it "returns error message" do
        data = perform(course_id: course.id, chapter_id: chapter.id, unit_id: "non_existent_id") 
        expect(data.class).to eq(GraphQL::ExecutionError)
        expect(data.message).to include("non_existent_id")
      end
    end
  end
end
