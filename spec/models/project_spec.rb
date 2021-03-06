require 'rails_helper'

RSpec.describe Project, type: :model do
  let(:user) { FactoryGirl.create(:user) }
  let(:portfolio) { FactoryGirl.create(:portfolio, user: user) }
  let(:project_input) do
    { title: 'My title',
      description: 'So many words',
      role: 'supreme leader',
      link: 'the-fun-place',
      tech: 'mostly interent explorer',
      order: 1 }
  end
  let(:project) { portfolio.projects.new(project_input) }

  describe '#create' do
    it 'creates new project' do
      portfolio.projects.create(project_input)
      expect(portfolio.projects.all.count).to eq(1)
    end
    it 'uploads image using ImageUploader' do
      image = fixture_file_upload('images/test.jpg')
      portfolio.projects.create(image: image)
      expect(portfolio.projects.first.image.is_a?(ImageUploader)).to eq(true)
    end
  end

  describe '#update' do
    let(:project) { portfolio.projects.create(project_input) }
    it 'updates a project' do
      project.update(title: 'updated')
      expect(portfolio.projects.first.title).to eq('updated')
    end
  end

  describe '#portfolio' do
    it { should belong_to(:portfolio) }
  end

  describe '#order' do
    it 'validates order as a number' do
      record = portfolio.projects.new(project_input)
      record.order = '2'
      record.valid?
      expect(record.errors[:order]).to eq([])
      record.order = 'two'
      record.valid?
      expect(record.errors[:order]).to eq(['is not a number'])
    end
    it 'validates order as greater than 0' do
      record = portfolio.projects.new(project_input)
      record.order = 1
      record.valid?
      expect(record.errors[:order]).to eq([])
      record.order = 0
      record.valid?
      expect(record.errors[:order]).to eq(['must be greater than 0'])
    end
    it 'validates order as less than 20' do
      record = portfolio.projects.new(project_input)
      record.order = 19
      record.valid?
      expect(record.errors[:order]).to eq([])
      record.order = 20
      record.valid?
      expect(record.errors[:order]).to eq(['must be less than 20'])
    end
  end

  describe '#link' do
    project_attribute_has_maximum_length_of(200, :link)
  end

  describe '#role' do
    project_attribute_has_maximum_length_of(200, :role)
  end

  describe '#tech' do
    project_attribute_has_maximum_length_of(500, :tech)
  end

  describe '#description' do
    project_attribute_has_maximum_length_of(2000, :description)
  end

  describe '#title' do
    project_attribute_has_maximum_length_of(40, :title)
  end
end
