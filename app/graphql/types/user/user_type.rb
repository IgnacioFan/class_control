# frozen_string_literal: true

module Types
  module User
    class UserType < Types::BaseObject
      field :id, ID, null: false
      field :name, String, null: false
      field :email, String, null: false
    end
  end
end
