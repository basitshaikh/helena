require 'spec_helper'

describe Helena::Survey do
  it { expect(subject).to belong_to(:participant) }

  it { expect(subject).to have_many(:question_groups) }

  it 'has a valid factory' do
    expect(build :survey).to be_valid
  end

  it 'validates presence of name' do
    expect(build :survey, name: '').not_to be_valid
  end

  it 'validates uniqueness of name' do
    create :survey, name: 'Patric Star\'s favorit position'

    expect(build :survey, name: 'Patric Star\'s favorit position').not_to be_valid
  end
end