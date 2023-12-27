require "rails_helper"

RSpec.describe "Mutations::DeleteCourse" do
  def perform(**args)
    Mutations::DeleteCourse.new(object: nil, field: nil, context: {}).resolve(**args)
  end

  let!(:course) { create(:course)}
  let!(:chapter) { create(:chapter, course: course)}
  let!(:units) { create_list(:unit, 2, chapter: chapter)}

  describe "#deleteCourse" do
    context "when success" do
      it "returns deleted course" do
        data = perform(id: course.id) 
        delete_course = data[:course]
        expect(delete_course.class).to eq(Course)
        expect(delete_course.id).to eq(course.id)
      end

      # TODO: change the operation to soft-delete
      it "removes the course, relevant chapters, and units" do
        expect{ perform(id: course.id) }.to \
          change(Course, :count).from(1).to(0).and \
          change(Chapter, :count).from(1).to(0).and \
          change(Unit, :count).from(2).to(0)
      end
    end

    context "when id not found" do
      it "returns deleted course" do
        data = perform(id: -1) 
        expect(data.class).to eq(GraphQL::ExecutionError)
        expect(data.message).to eq("Couldn't find Course with 'id'=-1")
      end
    end
  end
end
