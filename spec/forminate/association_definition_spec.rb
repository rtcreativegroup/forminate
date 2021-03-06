require 'spec_helper'

describe Forminate::AssociationDefinition do
  let(:options) { {} }

  subject { Forminate::AssociationDefinition.new(DummyUser, options) }

  describe '#attributes' do
    it 'returns a list of attributes from the appropriate class' do
      expect(subject.attributes).to eq(%w(id first_name last_name email))
    end
  end

  describe '#validation_condition' do
    context 'options hash does not contain :validate key' do
      it 'returns true' do
        expect(subject.validation_condition).to be true
      end
    end

    context 'options hash contains :validate key' do
      let(:options) { { validate: :stars_aligned? } }

      it 'returns the value' do
        expect(subject.validation_condition).to eq(:stars_aligned?)
      end
    end
  end
end
