require "rails_helper"

RSpec.describe "Mutations::CreateCourse" do
  def perform(**args)
    Mutations::CreateCourse.new(object: nil, field: nil, context: { current_user: current_user }).resolve(**args)
  end

  let!(:current_user) { create(:user) }

  subject { perform(input: params)[:course] }

  context "when success" do
    context "when creates a course" do
      let(:params) {
        {
          name: "test"
        }
      }
      it_behaves_like "build course"
    end

    context "when creates a course and chapters" do
      let(:params) {
        {
          name: "test",
          chapters: [
            { name: "Chapter 1" },
            { name: "Chapter 2" },
          ]
        }
      }
      it_behaves_like "build course"
    end

    context "when creates a course, chapters and units" do
      let(:params) {
        {
          name: "test",
          chapters: [
            {
              name: "Chapter", 
              units: [
                {
                  name: "Unit", 
                  description: "Test", 
                  content: "Mock data"
                }
              ]
            }
          ]
        }
      }
      it_behaves_like "build course"
    end
  end

  context "when failure" do
    context "when name is blank" do
      let(:params) {
        {
          name: ""
        }
      }
      it "returns error message" do
        data = perform(input: params) 
        expect(data.class).to eq(GraphQL::ExecutionError)
        expect(data.message).to include("The following errors were found: Name can't be blank")
      end
    end
  end
end
