require "rails_helper"

RSpec.describe "Mutations::ReorderUnits" do
  def perform(**args)
    Mutations::ReorderUnits.new(object: nil, field: nil, context: {}).resolve(**args)
  end

  let!(:course) { create(:course)}
  let!(:chapter) { create(:chapter, course: course)}
  let!(:unit1) { create(:unit, chapter: chapter, sort_key: 1)}
  let!(:unit2) { create(:unit, chapter: chapter, sort_key: 2)}
  let!(:unit3) { create(:unit, chapter: chapter, sort_key: 3)}

  describe "#reorderUnits" do
    let(:order) { [unit3.id, unit2.id, unit1.id] }

    context "when success" do
      it "updates the sort_key of the units" do
        perform(id: chapter.id, order: order) 
        expect(unit1.reload.sort_key).to eq(3)
        expect(unit2.reload.sort_key).to eq(2)
        expect(unit3.reload.sort_key).to eq(1)
      end
    end

    context "when failures" do
      context "when chapter ID doesn't exist" do
        it "returns error message" do
          data = perform(id: -1, order: order) 
          expect(data.class).to eq(GraphQL::ExecutionError)
          expect(data.message).to eq("Couldn't find Chapter with 'id'=-1")
        end
      end
    end
  end
end
