require "rails_helper"

RSpec.describe "Resolvers::Courses" do
  def perform(**args)
    Resolvers::Courses.new(object: nil, field: nil, context: { current_user: current_user }).resolve(**args)
  end

  let(:current_user) { "user1" }
  let!(:courses) { create_list(:course, 3) }

  after { Course.collection.drop }

  context "when success" do
    it "returns courses" do
      expect(perform.size).to eq(3)
    end
  end

  context "when failure" do
    context "when current_user not found" do
      let(:current_user) {}
      it "returns error message" do
        data = perform
        expect(data.class).to eq(GraphQL::ExecutionError)
        expect(data.message).to include("permission denied")
      end
    end
  end
end
