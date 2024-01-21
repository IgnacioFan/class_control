require "rails_helper"

RSpec.describe "Mutations::UpdateUnit" do
  def perform(**args)
    Mutations::UpdateUnit.new(object: nil, field: nil, context: {}).resolve(**args)
  end

  let!(:course) { create(:course)}
  let!(:chapter) { create(:chapter, course: course)}
  let!(:units) { create_list(:unit, 2, chapter: chapter)}
  let(:unit1) { units.first }

  describe "#updateUnit" do
    let(:input) {
      {
        name: "Unit updated",
        content: "Content updated"
      }
    }

    context "when success" do
      it "returns the updated unit" do
        data = perform(id: unit1.id.to_s, input: input) 
        updated_unit = data[:unit]
        expect(updated_unit.class).to eq(Unit)
        expect(updated_unit.id).to eq(unit1.id)
        expect(updated_unit.name).to eq("Unit updated")
        expect(updated_unit.content).to eq("Content updated")
      end
    end

    context "when id not found" do
      it "returns error message" do
        data = perform(id: -1, input: input) 
        expect(data.class).to eq(GraphQL::ExecutionError)
        expect(data.message).to eq("Couldn't find Unit with 'id'=-1")
      end
    end
  end
end
