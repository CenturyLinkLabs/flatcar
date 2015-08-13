require 'spec_helper'

describe Flatcar::PostgresService do

  subject { described_class.new }

  describe 'initialization' do
    it 'assigns a name' do
      expect(subject.name).to eql('postgresql')
    end
  end

  describe 'compose_block' do
    it 'returns a Docker Compose service definition' do
      fake_service_hash =
        {
          'db' => {
            'image' => 'postgres',
            'volumes_from' => [ 'data' ],
            'environment' => [ 'POSTGRES_PASSWORD=mysecretpassword' ]
          },
          'data' => {
            'image' => 'busybox',
            'volumes' => [ '/var/lib/postgresql' ]
          }
        }
      expect(subject.to_h).to eql(fake_service_hash)
    end
  end

  describe 'database_url' do
    it 'assigns a database url with password' do
      expect(subject.database_url).to eql('postgresql://postgres:mysecretpassword@db/')
    end
  end
end
