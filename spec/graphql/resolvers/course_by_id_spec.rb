require "rails_helper"

RSpec.describe "Resolvers::CourseById" do
  def perform(**args)
    Resolvers::CourseById.new(object: nil, field: nil, context: { current_user: current_user }).resolve(**args)
  end
  
  let(:current_user) { "user1" }
  let!(:course) { create(:course, name: "test", description: "") }

  after { Course.collection.drop }

  context "when success" do      
    it "returns a course" do
      get_course = perform(id: course.id) 
      expect(get_course.class).to eq(Course)
      expect(get_course.name).to eq("test")
      expect(get_course.description).to eq("")
    end
  end

  context "when failure" do
    context "when current_user not found" do
      let(:current_user) {}
      it "returns error message" do
        data = perform(id: "") 
        expect(data.class).to eq(GraphQL::ExecutionError)
        expect(data.message).to include("permission denied")
      end
    end

    context "when id not found" do
      it "returns error message" do
        data = perform(id: "non_existent_id") 
        expect(data.class).to eq(GraphQL::ExecutionError)
        expect(data.message).to include("non_existent_id")
      end
    end
  end
end
