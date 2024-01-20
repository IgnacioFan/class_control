require "rails_helper"

RSpec.describe "Resolvers::CourseById" do
  def perform(**args)
    Resolvers::CourseById.new(object: nil, field: nil, context: {}).resolve(**args)
  end

  let!(:course) { create(:course, name: "test", description: "")}
  let!(:chapter) { create(:chapter, course: course)}
  let!(:units) { create_list(:unit, 2, chapter: chapter)}

  context "when success" do      
    it "return a course" do
      data = perform(id: course.id.to_s) 
      update_course = data[:course]
      expect(course.class).to eq(Course)
      expect(course.name).to eq("test")
      expect(course.description).to eq("")
    end
  end

  context "when failure" do
    context "when id not found" do
      it "returns error message" do
        data = perform(id: -1) 
        expect(data.class).to eq(GraphQL::ExecutionError)
        expect(data.message).to eq("Couldn't find Course with 'id'=-1")
      end
    end
  end
end
