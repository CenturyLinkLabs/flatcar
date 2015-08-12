require 'spec_helper'

describe Flatcar::PostgresService do

  describe 'initialization' do

    context 'when using defaults' do
      it 'assigns a name' do
        expect(postgres.name).to eql('postgres')
      end
    end
  end

end