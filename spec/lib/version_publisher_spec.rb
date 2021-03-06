require 'spec_helper'

describe Helena::VersionPublisher do
  let!(:survey) { create :survey }
  let!(:source_version) { survey.versions.create version: 42, active: true }
  let!(:survey_detail) { source_version.survey_detail = build :survey_detail, title: 'Bla Bla' }
  let!(:question_group) { source_version.question_groups.create }
  let!(:question) { create(:radio_matrix_question, code: 'abc', question_group: question_group) }
  let!(:label) {  create(:label, text: 'xyz', value: 'asdf', question: question) }
  let!(:sub_question) { create(:sub_question, text: 'ymca', code: 'cde', question: question) }

  it 'creates a new version' do
    allow(Time).to receive(:now).and_return(Time.parse('Tue, 24 Jun 2014 10:24:08 +0200'))

    new_version = Helena::VersionPublisher.publish(source_version)
    new_version.save

    expect(new_version.version).to eq 43
    expect(new_version.survey_detail.title).to eq 'Bla Bla'

    expect(new_version).to have(1).question_groups
    expect(Helena::QuestionGroup.count).to eq 2
    expect(new_version.question_groups.first.id).not_to eq source_version.question_groups.first.id

    expect(new_version.question_groups.first).to have_exactly(1).questions
    expect(new_version.question_groups.first.questions.first.id).not_to eq source_version.question_groups.first.questions.first.id
    expect(Helena::Question.count).to eq 2

    expect(new_version.question_groups.first.questions.first).to have_exactly(1).labels
    expect(new_version.question_groups.first.questions.first).to have_exactly(1).sub_questions
    expect(new_version.created_at).to eq 'Tue, 24 Jun 2014 10:24:08 +0200'
    expect(new_version.updated_at).to eq 'Tue, 24 Jun 2014 10:24:08 +0200'
    expect(new_version.active).to be false
  end
end
