module Mutations
  class CreateCourse < BaseMutation
    argument :name, String, required: true
    argument :description, String

    type Types::CourseType

    def resolve(name: nil, description: "")
      Course.create!(name: name, description: description)
    rescue ActiveRecord::RecordInvalid => e
      GraphQL::ExecutionError.new("Invalid input: #{e.record.errors.full_messages.join(', ')}")
    end
  end
end
