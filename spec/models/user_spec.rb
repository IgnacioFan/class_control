# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  email           :string
#  name            :string
#  password_digest :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
require 'rails_helper'

RSpec.describe User, type: :model do
  describe "#validates" do
    context "when success" do
      subject { User.create(name: "test", email: "test@example.com", password: "1234") }

      it { is_expected.to be_valid }
    end

    context "when failure" do
      context "with no name" do
        subject { User.create(name: "", email: "test@example.com", password: "1234") }
  
        it { is_expected.not_to be_valid }
      end
  
      context "with no email" do
        subject { User.create(name: "test", email: "", password: "1234") }
  
        it { is_expected.not_to be_valid }
      end
  
      context "with no password" do
        subject { User.create(name: "test", email: "test@example.com", password: "") }
  
        it { is_expected.not_to be_valid }
      end
    end
  end
end
