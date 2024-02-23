require "rails_helper"

RSpec.describe "Mutations::UpdateCourse" do
  def perform(**args)
    Mutations::UpdateCourse.new(object: nil, field: nil, context: {}).resolve(**args)
  end

  let!(:course) { create(:course) }
  let!(:chapter) { create(:chapter, course: course) }
  let!(:unit) { create(:unit, chapter: chapter) }
  let(:params) {
    {
      name: "Course updated",
      description: "test test test",
    }
  }

  subject { perform(id: course.id, input: params)[:course] }

  context "when success" do
    context "when updates a course" do
      it_behaves_like "update course"
    end

    context "when updates a course with chapters" do
      let(:params) {
        {
          name: "Course updated",
          description: "test test test",
          chapters: [
            {
              id: chapter.id,
              name: "Chapter updated",
            }
          ]
        }
      }
      it_behaves_like "update course"
    end

    context "when updates a course with chapters and units" do
      let(:params) {
        {
          name: "Course updated",
          description: "test test test",
          chapters: [
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
          ]
        }
      }
      it_behaves_like "update course"
    end
  end

  context "when failure" do
    context "when id not found" do
      it "returns error message" do
        data = perform(id: "non_existent_id", input: params) 
        expect(data.class).to eq(GraphQL::ExecutionError)
        expect(data.message).to include("non_existent_id")
      end
    end
  end
end
