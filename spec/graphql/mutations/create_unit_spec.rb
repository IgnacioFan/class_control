require "rails_helper"

RSpec.describe "Mutations::CreateUnit" do
  def perform(**args)
    Mutations::CreateUnit.new(object: nil, field: nil, context: { current_user: current_user }).resolve(**args)
  end

  let(:current_user) { "user1" }
  let!(:course) { create(:course)}
  let!(:chapter) { create(:chapter, course: course)}
  let!(:units) { create_list(:unit, 2, chapter: chapter)}

  subject { perform(course_id: course.id, chapter_id: chapter.id, input: params)[:unit] }

  let(:params) {
    {
      name: "New unit name",
      description: "New unit desc",
      content: "New unit content"
    }
  }

  context "when success" do
    it "returns a unit" do
      new_unit = subject
      expect(new_unit.class).to eq(Unit)
      expect(new_unit.name).to eq("New unit name")
      expect(new_unit.description).to eq("New unit desc")
      expect(new_unit.content).to eq("New unit content")
      expect(new_unit.sort_key).to eq(3)
    end

    it "increases the number of units" do
      subject
      expect(chapter.reload.units.size).to eq(3)
    end
  end

  context "when failure" do
    context "when current_user not found" do
      let(:current_user) {}

      it "returns error message" do
        data = perform(course_id: course.id, chapter_id: "non_exsistent_id", input: params)
        expect(data.class).to eq(GraphQL::ExecutionError)
        expect(data.message).to include("permission denied")
      end
    end

    context "when chapter id not found" do
      it "returns error message" do
        data = perform(course_id: course.id, chapter_id: "non_exsistent_id", input: params)
        expect(data.class).to eq(GraphQL::ExecutionError)
        expect(data.message).to include("non_exsistent_id")
      end
    end

    context "when name and content are blank" do
      let(:params) {
        {
          name: "",
          description: "New unit desc",
          content: ""
        }
      }
      it "returns error message" do
        data = perform(course_id: course.id, chapter_id: chapter.id, input: params)
        expect(data.class).to eq(GraphQL::ExecutionError)
        expect(data.message).to include("The following errors were found: Name can't be blank, Content can't be blank")
      end
    end
  end
end
