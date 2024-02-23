require "rails_helper"

RSpec.describe "Mutations::UpdateChapter" do
  def perform(**args)
    Mutations::UpdateChapter.new(object: nil, field: nil, context: {}).resolve(**args)
  end

  let!(:course) { create(:course) }
  let!(:chapter) { create(:chapter, course: course) }
  let!(:unit) { create(:unit, chapter: chapter) }
  let(:params) {
    {
      id: chapter.id,
      name: "Chapter updated"
    }
  }

  subject { perform(course_id: course.id, input: params)[:chapter] }

  context "when success" do
    context "when updates a chapter" do
      it_behaves_like "update chapter"
    end

    context "when updates a chapter with units" do
      let(:params) {
        {
          id: chapter.id,
          name: "Chapter updated",
          units: [
            {
              id: unit.id,
              name: "Unit name updated",
              description: "Unit desc updated",
              content: "Unit content updated"
            }
          ]
        }
      }

      it_behaves_like "update chapter"
    end
  end

  context "when id not found" do
    it "returns error message" do
      data = perform(course_id: "non_existent_id", input: params)
      expect(data.class).to eq(GraphQL::ExecutionError)
      expect(data.message).to include("non_existent_id")
    end
  end
end
