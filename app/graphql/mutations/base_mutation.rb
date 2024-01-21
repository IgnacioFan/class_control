# frozen_string_literal: true

module Mutations
  class BaseMutation < GraphQL::Schema::Mutation
    EXCEPTIONS = [ActiveRecord::RecordInvalid, ActiveRecord::RecordNotFound]

    null false
  end
end
