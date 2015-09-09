require 'spec_helper'

describe Flatcar::WebappService do
  describe '#dockerfile' do
    let(:common_lines) {
      [
        'RUN mkdir -p /usr/src/app',
        'WORKDIR /usr/src/app',
        'COPY . /usr/src/app',
        'RUN bundle install',
        'EXPOSE 3000'
      ]
    }

    context 'when using defaults' do
      subject { described_class.new('rails', nil) }

      it 'includes the default base image instructions' do
        expect(subject.dockerfile).to eq([
                                           'FROM rails:latest',
                                           'RUN apt-get update && apt-get install -y nodejs --no-install-recommends && rm -rf /var/lib/apt/lists/*',
                                           'RUN apt-get update && apt-get install -y mysql-client postgresql-client sqlite3 --no-install-recommends && rm -rf /var/lib/apt/lists/*',
                                         ].push(common_lines).join("\n"))
      end
    end

    context 'when specifying the ubuntu base image' do
      subject { described_class.new('ubuntu', nil) }

      it 'includes the ubuntu base image instructions' do
        expect(subject.dockerfile).to eq([
                                           'FROM flatcar/ubuntu-rails'
                                         ].push(common_lines).join("\n"))
      end
    end

    context 'when specifying the debian base image' do
      subject { described_class.new('debian', nil) }

      it 'includes the debian base image instructions' do
        expect(subject.dockerfile).to eq([
                                           'FROM flatcar/debian-rails'
                                         ].push(common_lines).join("\n"))
      end
    end

    context 'when specifying the alpine base image' do
      context 'without a database' do
        subject { described_class.new('alpine', nil) }

        it 'includes the alpine base image instructions' do
          expect(subject.dockerfile).to eq([
                                             'FROM flatcar/alpine-rails',
                                           ].push(common_lines).join("\n"))
        end
      end

      context 'with a postgresql database' do
        let(:postgresql) { double('postgresql_service', name: 'postgresql') }

        subject { described_class.new('alpine', postgresql) }

        it 'includes the alpine base image instructions with the postgres libraries' do
          expect(subject.dockerfile).to eq([
                                             'FROM flatcar/alpine-rails'
                                           ].push(common_lines).join("\n"))
        end
      end

      context 'with a mysql database' do
        let(:mysql) { double('mysql_service', name: 'mysql') }

        subject { described_class.new('alpine', mysql) }

        it 'includes the alpine base image instructions with the mysql libraries' do
          expect(subject.dockerfile).to eq([
                                             'FROM flatcar/alpine-rails'
                                           ].push(common_lines).join("\n"))
        end
      end
    end
  end

  describe '#service_link' do
    let(:db_service) { double('db_service', database_url: 'db_service_url') }

    subject { described_class.new('rails', db_service) }

    it 'sets the database url environment variable' do
      expect(subject.send(:service_link)).to eq({
                                                  'environment' => ["DATABASE_URL=db_service_url"],
                                                  'links' => ['db:db']
                                                })
    end
  end

  describe '#to_h' do
    let(:service_hash) {
      {
        'webapp' => {
          'build' => '.',
          'ports' => ['3000:3000'],
          'volumes' => ['.:/usr/src/app'],
          'working_dir' => '/usr/src/app',
          'command' => "bundle exec rails s -b '0.0.0.0'"
        }
      }
    }

    context 'when there is a database service' do
      let(:db_service) { double('db_service', database_url: 'db_service_url') }

      subject { described_class.new('rails', db_service) }

      it 'includes the service link in the webapp compose yaml representation' do

        service_hash['webapp'].merge!(
          'environment' => ["DATABASE_URL=#{db_service.database_url}"],
          'links' => ['db:db']
        )
        expect(subject.to_h).to eql(service_hash)
      end
    end

    context 'without a database service' do
      subject { described_class.new('rails', nil) }

      it 'returns the webapp compose yaml representation' do
        expect(subject.to_h).to eq(service_hash)
      end
    end
  end
end
