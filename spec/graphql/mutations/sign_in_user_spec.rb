require "rails_helper"

RSpec.describe "Mutations::SignInUser" do
  def perform(**args)
    Mutations::SignInUser.new(object: nil, field: nil, context: { session: {} }).resolve(**args)
  end

  let!(:user) { create(:user, name: "Test User", email: "email@example.com", password: "1234") }

  context "when success" do
    context "when creates new user" do
      it "returns a user and token" do
        data = perform(credentials: {
          email: "email@example.com",
          password: "1234"
        })
        user = data[:user]
        expect(user.name).to eq("Test User")
        expect(user.email).to eq("email@example.com")

        token = data[:token]
        expect(token).to be_present
      end
    end
  end

  context "when failure" do
    context "when email doesn't match" do
      it "returns error message" do
        data = perform(credentials: {
          email: "email_test@example.com",
          password: "1234"
        })
        expect(data.class).to eq(GraphQL::ExecutionError)
        expect(data.message).to eq("invalid email/password")
      end
    end
    
    context "when password does not match" do
      it "returns error message" do
        data = perform(credentials: {
          email: "email@example.com",
          password: "wrong"
        })
        expect(data.class).to eq(GraphQL::ExecutionError)
        expect(data.message).to eq("invalid email/password")
      end
    end
  end
end
