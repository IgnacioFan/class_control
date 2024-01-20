require "rails_helper"

RSpec.describe "Resolvers::UnitById" do
  def perform(**args)
    Resolvers::UnitById.new(object: nil, field: nil, context: {}).resolve(**args)
  end

  let!(:unit) { create(:unit, name: "test") }

  context "when success" do      
    it "returns a unit" do
      get_unit = perform(id: unit.id.to_s) 
      expect(get_unit.class).to eq(Unit)
      expect(get_unit.name).to eq("test")
    end
  end

  context "when failure" do
    context "when id not found" do
      it "returns error message" do
        data = perform(id: -1) 
        expect(data.class).to eq(GraphQL::ExecutionError)
        expect(data.message).to eq("Couldn't find Unit with 'id'=-1")
      end
    end
  end
end
