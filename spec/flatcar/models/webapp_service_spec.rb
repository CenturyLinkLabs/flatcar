require 'spec_helper'

describe Flatcar::WebappService do

  describe 'initialization' do

    context 'when using defaults' do
      it 'assigns a name' do
        expect(webapp.base_image).to eql('base_image')
        expect(webapp.database).to eql('database_of_some_sort')
      end
    end
  end

end