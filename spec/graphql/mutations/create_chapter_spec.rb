require "rails_helper"

RSpec.describe "Mutations::CreateChapter" do
  def perform(**args)
    Mutations::CreateChapter.new(object: nil, field: nil, context: {}).resolve(**args)
  end

  let!(:course) { create(:course)}
  let!(:chapter) { create(:chapter, course: course)}
  let!(:units) { create_list(:unit, 2, chapter: chapter)}

  describe "#createChapter" do
    let(:input) {
      {
        name: "New Chapter"
      }
    }

    context "when success" do
      context "when creates a chapter" do
        it "returns a new chapter" do
          data = perform(id: course.id, input: input) 
        
          new_chapter = data[:chapter]
          expect(new_chapter.class).to eq(Chapter)
          expect(new_chapter.name).to eq("New Chapter")
          expect(new_chapter.sort_key).to eq(2)
        end

        it "increase chapters" do
          expect{ perform(id: course.id, input: input)  }.to \
            change(Chapter, :count).from(1).to(2).and \
            change(Unit, :count).by(0)
        end
      end

      context "when creates a chapter with units" do
        let(:input) {
          {
            name: "New Chapter",
            units: [
              {
                name: "New Unit 1",
                description: "New Unit 1 description",
                content: "New Unit 1 content"
              },
              {
                name: "New Unit 2",
                description: "New Unit 2 description",
                content: "New Unit 2 content"
              }
            ]
          }
        }

        it "returns a new chapter and units" do
          data = perform(id: course.id, input: input) 
        
          new_chapter = data[:chapter]
          expect(new_chapter.class).to eq(Chapter)
          expect(new_chapter.name).to eq("New Chapter")
          expect(new_chapter.sort_key).to eq(2)
        end 
        
        it "increases chapters and units" do
          expect{ perform(id: course.id, input: input)  }.to \
            change(Chapter, :count).from(1).to(2).and \
            change(Unit, :count).from(2).to(4)
        end
      end
    end

    context "when id not found" do
      it "returns error message" do
        data = perform(id: -1, input: input) 
        expect(data.class).to eq(GraphQL::ExecutionError)
        expect(data.message).to eq("Validation failed: Course must exist")
      end
    end
  end
end
