require "rails_helper"

RSpec.describe "Mutations::DeleteUnit" do
  def perform(**args)
    Mutations::DeleteUnit.new(object: nil, field: nil, context: {}).resolve(**args)
  end

  let!(:course) { create(:course) }
  let!(:chapter) { create(:chapter, course: course) }
  let!(:unit) { create(:unit, chapter: chapter) }

  subject { perform(course_id: course.id, chapter_id: chapter.id, unit_id: unit.id) }

  after { Course.collection.drop }

  context "when success" do
    it "returns unit" do
      delete_unit = subject[:unit]
      expect(delete_unit.class).to eq(Unit)
      expect(delete_unit.id).to eq(unit.id)
    end

    it "removes unit" do
      subject
      expect(course.reload.chapters).to eq([chapter])
      expect(chapter.reload.units).to eq([])
    end
  end

  context "when failure" do
    context "when id not found" do
      it "returns error message" do
        data = perform(course_id: course.id, chapter_id: chapter.id, unit_id: "non_exsistent_id")
        expect(data.class).to eq(GraphQL::ExecutionError)
        expect(data.message).to include("non_exsistent_id")
      end
    end
  end
end
