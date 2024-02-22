require "rails_helper"

RSpec.describe "Mutations::DeleteCourse" do
  def perform(**args)
    Mutations::DeleteCourse.new(object: nil, field: nil, context: {}).resolve(**args)
  end

  let!(:course) { create(:course) }

  subject { perform(id: course.id) }

  after { Course.collection.drop }

  context "when success" do
    it "returns course" do
      delete_course = subject[:course]
      expect(delete_course.class).to eq(Course)
      expect(delete_course.id).to eq(course.id)
    end

    it "removes course" do
      expect{ subject }.to change(Course, :count).from(1).to(0)
    end
  end

  context "when failure" do
    context "when id not found" do
      it "returns error message" do
        data = perform(id: "non_exsistent_id") 
        expect(data.class).to eq(GraphQL::ExecutionError)
        expect(data.message).to include("non_exsistent_id")
      end
    end
  end
end
