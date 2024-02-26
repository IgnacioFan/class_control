require "rails_helper"

RSpec.describe "Mutations::CreateUser" do
  def perform(**args)
    Mutations::CreateUser.new(object: nil, field: nil, context: {}).resolve(**args)
  end

  let(:auth_provider) {
    {
      credentials: {
        email: "email@example.com",
        password: "1234"
      }
    }
  }

  subject { perform(name: "Test User", auth_provider: auth_provider) }

  context "when success" do
    context "when creates new user" do
      it "returns a user" do
        user = subject[:user]
        expect(user.name).to eq("Test User")
        expect(user.email).to eq("email@example.com")
      end
    end
  end

  context "when failure" do
    context "when user exists" do
      before { create(:user, email: "email@example.com") }

      it "returns error message" do
        data = subject
        expect(data.class).to eq(GraphQL::ExecutionError)
        expect(data.message).to eq("Validation failed: Email has already been taken")
      end
    end
  end
end
