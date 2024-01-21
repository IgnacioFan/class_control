require "rails_helper"

RSpec.describe "Resolvers::ChapterById" do
  def perform(**args)
    Resolvers::ChapterById.new(object: nil, field: nil, context: {}).resolve(**args)
  end

  let!(:chapter) { create(:chapter, name: "test") }

  context "when success" do      
    it "returns a chapter" do
      get_chapter = perform(id: chapter.id.to_s) 
      expect(get_chapter.class).to eq(Chapter)
      expect(get_chapter.name).to eq("test")
    end
  end

  context "when failure" do
    context "when id not found" do
      it "returns error message" do
        data = perform(id: -1) 
        expect(data.class).to eq(GraphQL::ExecutionError)
        expect(data.message).to eq("Couldn't find Chapter with 'id'=-1")
      end
    end
  end
end
