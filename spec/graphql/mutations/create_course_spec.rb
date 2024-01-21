require "rails_helper"

RSpec.describe "Mutations::CreateCourse" do
  def perform(**args)
    Mutations::CreateCourse.new(object: nil, field: nil, context: {}).resolve(**args)
  end

  let(:input) {
    {
      name: "test",
      chapters: chapters
    }
  }

  describe "create a new course" do
    context "when success" do
      context "with only course info" do
        let(:chapters) { nil }

        it "return a course" do
          data = perform(input: input) 
          course = data[:course]
          expect(course.class).to eq(Course)
          expect(course.name).to eq("test")
          expect(course.description).to eq("")
        end
      end

      context "with course and chapters info" do
        let(:chapters) {
          [
            {name: "Chapter 1"},
            {name: "Chapter 2"},
          ]
        }

        it "return a course" do
          data = perform(input: input) 
          course = data[:course]
          expect(course.class).to eq(Course)
          expect(course.name).to eq("test")
          expect(course.description).to eq("")
          expect(course.chapters.size).to eq(2)

          chapter1 = course.chapters.first
          expect(chapter1.class).to eq(Chapter)
          expect(chapter1.name).to eq("Chapter 1")
        end
      end

      context "with course and chapters info" do
        let(:chapters) {
          [
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

        it "return a course" do
          data = perform(input: input) 
          course = data[:course]
          expect(course.class).to eq(Course)
          expect(course.name).to eq("test")
          expect(course.description).to eq("")
          expect(course.chapters.size).to eq(1)

          chapter = course.chapters.first
          expect(chapter.class).to eq(Chapter)
          expect(chapter.name).to eq("Chapter")

          unit = chapter.units.first
          expect(unit.class).to eq(Unit)
          expect(unit.name).to eq("Unit")
          expect(unit.description).to eq("Test")
          expect(unit.content).to eq("Mock data")
        end
      end
    end
  end
end
