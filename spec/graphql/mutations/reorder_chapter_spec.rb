require "rails_helper"

RSpec.describe "Mutations::ReorderChapter" do
  def perform(**args)
    Mutations::ReorderChapter.new(object: nil, field: nil, context: {}).resolve(**args)
  end

  let!(:course) { create(:course)}
  let!(:chapter1) { create(:chapter, course: course, sort_key: 1)}
  let!(:chapter2) { create(:chapter, course: course, sort_key: 2)}
  let!(:chapter3) { create(:chapter, course: course, sort_key: 3)}

  describe "#updateCourse" do
    let(:order) { [chapter3.id, chapter2.id, chapter1.id] }

    context "when success" do
      it "updates the sort_key of the chapters" do
        perform(id: course.id, order: order) 
        expect(chapter1.reload.sort_key).to eq(3)
        expect(chapter2.reload.sort_key).to eq(2)
        expect(chapter3.reload.sort_key).to eq(1)
      end
    end
  end
end
