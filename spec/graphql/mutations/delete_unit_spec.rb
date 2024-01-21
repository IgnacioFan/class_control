require "rails_helper"

RSpec.describe "Mutations::DeleteUnit" do
  def perform(**args)
    Mutations::DeleteUnit.new(object: nil, field: nil, context: {}).resolve(**args)
  end

  let!(:course) { create(:course)}
  let!(:chapter) { create(:chapter, course: course)}
  let!(:units) { create_list(:unit, 2, chapter: chapter)}
  let(:unit1) { units.first }

  describe "#deleteUnit" do
    context "when success" do
      it "returns deleted unit" do
        data = perform(id: unit1.id.to_s) 
        delete_unit = data[:unit]
        expect(delete_unit.class).to eq(Unit)
        expect(delete_unit.id).to eq(unit1.id)
      end

      # TODO: change the operation to soft-delete
      it "removes the course, relevant chapters, and units" do
        expect{ perform(id: unit1.id.to_s) }.to \
          change(Unit, :count).from(2).to(1)
      end
    end

    context "when id not found" do
      it "returns error message" do
        data = perform(id: -1) 
        expect(data.class).to eq(GraphQL::ExecutionError)
        expect(data.message).to eq("Couldn't find Unit with 'id'=-1")
      end
    end
  end
end
