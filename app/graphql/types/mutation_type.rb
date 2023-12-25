# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    # create/update/delete a course
    field :create_course, mutation: Mutations::CreateCourse
  end
end
