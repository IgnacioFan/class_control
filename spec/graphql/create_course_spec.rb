require "rails_helper"

RSpec.describe "Mutations::CreateCourse" do
  def perform(**args)
    Mutations::CreateCourse.new(object: nil, field: nil, context: {}).resolve(**args)
  end

  describe "create a new course" do
    it "return a course" do
      course = perform(
        name: "test"
      ) 
      expect(course.name).to eq("test")
      expect(course.description).to eq("")
    end
  end
end
