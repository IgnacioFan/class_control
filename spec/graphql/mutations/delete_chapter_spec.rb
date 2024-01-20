require "rails_helper"

RSpec.describe "Mutations::DeleteChapter" do
  def perform(**args)
    Mutations::DeleteChapter.new(object: nil, field: nil, context: {}).resolve(**args)
  end

  let!(:course) { create(:course)}
  let!(:chapter) { create(:chapter, course: course)}
  let!(:units) { create_list(:unit, 2, chapter: chapter)}

  describe "#deleteChapter" do
    context "when success" do
      it "returns deleted chapter" do
        data = perform(id: chapter.id.to_s) 
        delete_chapter = data[:chapter]
        expect(delete_chapter.class).to eq(Chapter)
        expect(delete_chapter.id).to eq(chapter.id)
      end

      # TODO: change the operation to soft-delete
      it "removes the chapter, and relevant units" do
        expect{ perform(id: chapter.id.to_s) }.to \
          change(Chapter, :count).from(1).to(0).and \
          change(Unit, :count).from(2).to(0)
      end
    end

    context "when id not found" do
      it "returns error message" do
        data = perform(id: -1) 
        expect(data.class).to eq(GraphQL::ExecutionError)
        expect(data.message).to eq("Couldn't find Chapter with 'id'=-1")
      end
    end
  end
end
