require 'spec_helper'

describe Flatcar::MysqlService do

  subject { described_class.new }

  describe 'initialization' do
    it 'assigns a name' do
      expect(subject.name).to eql('mysql')
    end
  end

  describe 'to_h' do
    it 'returns a hash' do
      fake_service_hash =
        {
          'db' => {
            'image' => 'mysql',
            'volumes_from' => [ 'data' ],
            'environment' => [ 'MYSQL_ROOT_PASSWORD=mysecretpassword' ]
          },
          'data' => {
            'image' => 'busybox',
            'volumes' => [ '/var/lib/mysql' ]
          }
        }
      expect(subject.to_h).to eql(fake_service_hash)
    end
  end

  describe 'database_url' do
    it 'assigns a database url with password' do
      expect(subject.database_url).to eql('mysql2://root:mysecretpassword@db/')
    end
  end
end
