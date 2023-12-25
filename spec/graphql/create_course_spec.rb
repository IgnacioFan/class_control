require "rails_helper"

RSpec.describe "Mutations::CreateCourse" do
  def perform(**args)
    Mutations::CreateCourse.new(object: nil, field: nil, context: {}).resolve(**args)
  end

  let(:input) {
    {
      name: "test"
    }
  }

  describe "create a new course" do
    context "when input is valid" do
      it "return a course" do
        data = perform(input: input) 
        course = data[:course]
        expect(course[:name]).to eq("test")
        expect(course[:description]).to eq("")
      end
    end
  end
end
