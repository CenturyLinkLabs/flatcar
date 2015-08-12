require 'spec_helper'

describe Flatcar::Service do
  let(:options) { { name: 'webapp'} }
  let(:postgres_database) { double('postgres_service', name: 'postgresql') }
  let(:mysql_database) { double('mysql_service', name: 'mysql') }
  let(:webapp) { double('webapp_service', name: 'webapp') }

  before do
  end

  describe('.instance') do
    context 'when the service type is webapp' do
      it 'attempts to instantiate a webapp service' do
        expect(Flatcar::WebappService).to receive(:new)
        Flatcar::Service.instance('webapp')
      end
    end

    context 'when the service type is postgres' do
      it 'attempts to instantiate a postgres service' do
        expect(Flatcar::PostgresService).to receive(:new)
        Flatcar::Service.instance('postgresql')
      end
    end

    context 'when the service type is mysql' do
      it 'attempts to instantiate a mysql service' do
        expect(Flatcar::MysqlService).to receive(:new)
        Flatcar::Service.instance('mysql')
      end
    end

    context 'when the service type is invalid' do
      it 'raises an exception' do
        expect(Flatcar::Service).to receive(:instance).with('foobar').and_return(Exception.new)
        Flatcar::Service.instance('foobar')
      end
    end
  end
end
