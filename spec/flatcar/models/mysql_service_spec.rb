require 'spec_helper'

describe Flatcar::MysqlService do

  let(:mysql) { double('mysql_service') }

  describe 'initialization' do

    context 'when using defaults' do
      it 'assigns a name' do
        expect(mysql.name).to eql('mysql')
      end
    end
  end
end
