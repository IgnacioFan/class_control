require "rails_helper"

RSpec.describe "Mutations::UpdateChapter" do
  def perform(**args)
    Mutations::UpdateChapter.new(object: nil, field: nil, context: {}).resolve(**args)
  end

  let!(:course) { create(:course)}
  let!(:chapter) { create(:chapter, course: course)}
  let!(:units) { create_list(:unit, 2, chapter: chapter)}
  let(:unit1) { units.first }

  describe "#updateChapter" do
    let(:input) {
      {
        name: "Chapter updated",
      }
    }

    context "when success" do
      it "returns the updated chapter" do
        data = perform(id: chapter.id.to_s, input: input) 
        updated_chapter = data[:chapter]
        expect(updated_chapter.class).to eq(Chapter)
        expect(updated_chapter.id).to eq(chapter.id)
        expect(updated_chapter.name).to eq("Chapter updated")
      end

      context "when includes units" do
        let(:input) {
          {
            name: "Chapter updated",
            units: [
              {
                id: unit1.id.to_s,
                name: "Unit name updated",
                description: "Unit desc updated",
                content: "Unit content updated"
              }
            ]
          }
        }

        it "returns updated chapter and units" do
          data = perform(id: chapter.id, input: input) 
          updated_chapter = data[:chapter]
          expect(updated_chapter.class).to eq(Chapter)
          expect(updated_chapter.id).to eq(chapter.id)
          expect(updated_chapter.name).to eq("Chapter updated")

          updated_unit = updated_chapter.units.first
          expect(updated_unit.name).to eq("Unit name updated")
          expect(updated_unit.description).to eq("Unit desc updated")
          expect(updated_unit.content).to eq("Unit content updated")
        end
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
