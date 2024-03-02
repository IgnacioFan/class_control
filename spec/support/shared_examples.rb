RSpec.shared_examples "build course" do 
  
  before { Course.collection.drop }

  it "returns course" do
    course = subject
    expect(course.name).to eq(params[:name])
    expect(course.author).to eq(current_user)
    next unless params[:chapters].present?

    expect(course.chapters.count).to eq(params[:chapters].count) 
    
    params[:chapters].each_with_index do |chapter_params, chapter_index|
      chapter = course.chapters[chapter_index]
      expect(chapter.name).to eq(chapter_params[:name])
      next unless chapter_params[:units].present?

      expect(chapter.units.count).to eq(chapter_params[:units].count) 
        
      chapter_params[:units].each_with_index do |unit_params, unit_index|
        unit = chapter.units[unit_index]
        expect(unit.name).to eq(unit_params[:name])
        expect(unit.description).to eq(unit_params[:description])
        expect(unit.content).to eq(unit_params[:content])
      end
    end
  end
end

RSpec.shared_examples "update course" do
  
  after { Course.collection.drop }

  it "returns course" do
    course = subject
    expect(course.name).to eq(params[:name])
    next unless params[:chapters].present?
    
    params[:chapters].each do |chapter_params|
      chapter = course.chapters.find_by(name: chapter_params[:name])
      expect(chapter.name).to eq(chapter_params[:name])
      next unless chapter_params[:units].present?
        
      chapter_params[:units].each do |unit_params|
        unit = chapter.units.find_by(name: unit_params[:name])
        expect(unit.name).to eq(unit_params[:name])
        expect(unit.description).to eq(unit_params[:description])
        expect(unit.content).to eq(unit_params[:content])
      end
    end
  end
end

RSpec.shared_examples "build chapter" do 
  
  after { Course.collection.drop }

  it "returns chapter" do
    chapter = subject
    expect(chapter.name).to eq(params[:name])
    next unless params[:units].present?

    expect(chapter.units.count).to eq(params[:units].count) 
        
    params[:units].each_with_index do |unit_params, unit_index|
      unit = chapter.units[unit_index]
      expect(unit.name).to eq(unit_params[:name])
      expect(unit.description).to eq(unit_params[:description])
      expect(unit.content).to eq(unit_params[:content])
    end
  end
end

RSpec.shared_examples "update chapter" do
  
  after { Course.collection.drop }

  it "returns chapter" do
    chapter = subject
    expect(chapter.name).to eq(params[:name])
    next unless params[:units].present?
        
    params[:units].each do |unit_params|
      unit = chapter.units.find_by(name: unit_params[:name])
      expect(unit.name).to eq(unit_params[:name])
      expect(unit.description).to eq(unit_params[:description])
      expect(unit.content).to eq(unit_params[:content])
    end
  end
end
