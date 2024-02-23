require "rails_helper"

RSpec.describe "Resolvers::Courses" do
  def perform(**args)
    Resolvers::Courses.new(object: nil, field: nil, context: {}).resolve(**args)
  end

  let!(:courses) { create_list(:course, 3) }

  after { Course.collection.drop }

  context "when success" do
    it "returns courses" do
      expect(perform.size).to eq(3)
    end
  end
end
