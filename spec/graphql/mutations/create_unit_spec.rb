require "rails_helper"

RSpec.describe "Mutations::CreateUnit" do
  def perform(**args)
    Mutations::CreateUnit.new(object: nil, field: nil, context: {}).resolve(**args)
  end

  let!(:course) { create(:course)}
  let!(:chapter) { create(:chapter, course: course)}
  let!(:units) { create_list(:unit, 2, chapter: chapter)}
  let(:unit1) { units.first }

  describe "#createUnit" do
    let(:input) {
      {
        name: "New unit name",
        description: "New unit desc",
        content: "New unit content"
      }
    }

    context "when success" do
      it "returns a unit" do
        data = perform(id: chapter.id.to_s, input: input) 
        new_unit = data[:unit]
        expect(new_unit.class).to eq(Unit)
        expect(new_unit.name).to eq("New unit name")
        expect(new_unit.description).to eq("New unit desc")
        expect(new_unit.content).to eq("New unit content")
        expect(new_unit.sort_key).to eq(3)
      end

      it "increases a unit" do
        expect{ perform(id: course.id, input: input)  }.to \
          change(Unit, :count).from(2).to(3)
      end
    end

    context "when id not found" do
      it "returns error message" do
        data = perform(id: -1, input: input) 
        expect(data.class).to eq(GraphQL::ExecutionError)
        expect(data.message).to eq("Couldn't find Chapter with 'id'=-1")
      end
    end
  end
end
