require "rails_helper"

RSpec.describe "Mutations::CreateChapter" do
  def perform(**args)
    Mutations::CreateChapter.new(object: nil, field: nil, context: {}).resolve(**args)
  end

  let!(:course) { create(:course) }
  let!(:chapter) { create(:chapter, course: course) }
  let!(:units) { create_list(:unit, 2, chapter: chapter) }

  subject { perform(course_id: course.id, input: params)[:chapter] }

  context "when success" do
    context "when creates a chapter" do
      let(:params) {
        {
          name: "New Chapter"
        }
      }

      it_behaves_like "build chapter"

      it "increases the number of chapters" do
        subject
        expect(course.reload.chapters.size).to eq(2)
      end
    end

    context "when creates a chapter with units" do
      let(:params) {
        {
          name: "New Chapter",
          units: [
            {
              name: "New Unit 1",
              description: "New Unit 1 description",
              content: "New Unit 1 content"
            },
            {
              name: "New Unit 2",
              description: "New Unit 2 description",
              content: "New Unit 2 content"
            }
          ]
        }
      }

      it_behaves_like "build chapter"
      
      it "increases the number of chapters and units" do
        new_chapter = subject
        expect(course.reload.chapters.size).to eq(2)
        expect(new_chapter.units.size).to eq(2)
      end
    end
  end

  context "when failure" do
    context "when course id not found" do
      let(:params) {
        {
          name: "test"
        }
      }
      it "returns error message" do
        data = perform(course_id: "non_exsistent_id", input: params) 
        expect(data.class).to eq(GraphQL::ExecutionError)
        expect(data.message).to include("non_exsistent_id")
      end
    end

    context "when name is blank" do
      let(:params) {
        {
          name: ""
        }
      }
      it "returns error message" do
        data = perform(course_id: course.id, input: params) 
        expect(data.class).to eq(GraphQL::ExecutionError)
        expect(data.message).to eq("The following errors were found: Name can't be blank")
      end
    end
  end
end
