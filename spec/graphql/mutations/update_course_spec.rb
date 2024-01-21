require "rails_helper"

RSpec.describe "Mutations::UpdateCourse" do
  def perform(**args)
    Mutations::UpdateCourse.new(object: nil, field: nil, context: {}).resolve(**args)
  end

  let!(:course) { create(:course)}
  let!(:chapter) { create(:chapter, course: course)}
  let!(:units) { create_list(:unit, 2, chapter: chapter)}

  describe "#updateCourse" do
    let(:input) {
      {
        name: "Rails",
        lecturer: "Test",
        description: "test test test",
      }
    }

    context "when success" do
      it "returns update course" do
        data = perform(id: course.id, input: input) 
        update_course = data[:course]
        expect(update_course.class).to eq(Course)
        expect(update_course.id).to eq(course.id)
        expect(update_course.name).to eq("Rails")
      end
    end

    context "when id not found" do
      it "returns error message" do
        data = perform(id: -1, input: input) 
        expect(data.class).to eq(GraphQL::ExecutionError)
        expect(data.message).to eq("Couldn't find Course with 'id'=-1")
      end
    end
  end
end
