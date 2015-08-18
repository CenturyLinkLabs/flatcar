require 'spec_helper'

describe Flatcar::Project do
  let(:default_options) { { b: 'rails', d: 'sqlite3' } }
  let(:args) { [ 'app_name' ] }
  let(:service_hash) { { 'foo' => 'bar' } }
  let(:webapp) { double('webapp_service', dockerfile: 'FROM foo', to_h: service_hash) }

  before do
    allow_any_instance_of(Flatcar::Project).to receive(:system)
  end

  describe '.init' do
    let(:project) { double('project', write_dockerfile: true, write_compose_yaml: true, docker_build: true) }

    before do
      allow(Flatcar::Project).to receive(:new).and_return(project)
    end

    after do
      described_class.init(default_options, args)
    end

    it 'instantiates a new Project' do
      expect(Flatcar::Project).to receive(:new).with(default_options, args)
    end

    it 'writes the dockerfile' do
      expect(project).to receive(:write_dockerfile)
    end

    it 'writes the docker-compose.yml' do
      expect(project).to receive(:write_compose_yaml)
    end

    it 'calls docker-compose build' do
      expect(project).to receive(:docker_build)
    end
  end

  describe 'initialization' do

    context 'when using defaults' do
      before do
        allow(Flatcar::Service).to receive(:instance).with('sqlite3')
        allow(Flatcar::Service).to receive(:instance).with('webapp', base_image: 'rails', database: nil)
      end

      it 'calls Rails new with the -B flag and the app_name' do
        expect_any_instance_of(Flatcar::Project).to receive(:system).with('rails new -B app_name')
        Flatcar::Project.new(default_options, args)
      end
    end

    context 'when specifying a database other than sqlite3' do
      let(:options) { { b: 'rails', d: 'postgresql' } }
      let(:database) { double('database_service', name: 'postgresql') }

      before do
        allow(Flatcar::Service).to receive(:instance).with('postgresql').and_return(database)
        allow(Flatcar::Service).to receive(:instance).with('webapp', base_image: 'rails', database: database)
      end

      it 'instantiates the postgres database service' do
        expect(Flatcar::Service).to receive(:instance).with('postgresql').and_return(database)
        Flatcar::Project.new(options, args)
      end

      it 'calls Rails new with the -d option' do
        expect_any_instance_of(Flatcar::Project).to receive(:system).with('rails new -B app_name -d postgresql')
        Flatcar::Project.new(options, args)
      end
    end

    context 'when specifying a base image other than rails' do
      let(:options) { { b: 'alpine', d: 'sqlite3' } }

      before do
        allow(Flatcar::Service).to receive(:instance).with('sqlite3')
        allow(Flatcar::Service).to receive(:instance).with('webapp', base_image: 'alpine', database: nil)
      end

      it 'instantiates the webapp service with the base image' do
        expect(Flatcar::Service).to receive(:instance).with('webapp', base_image: 'alpine', database: nil)
        Flatcar::Project.new(options, args)
      end

      it 'calls Rails new with the -B flag and the app_name' do
        expect_any_instance_of(Flatcar::Project).to receive(:system).with('rails new -B app_name')
        Flatcar::Project.new(options, args)
      end
    end

    describe 'when various switches and flags are used' do
      before do
        allow(Flatcar::Service).to receive(:instance).with('sqlite3')
        allow(Flatcar::Service).to receive(:instance).with('webapp', base_image: 'rails', database: nil)
      end

      context '--skip-git' do
        let(:options) do
          { b: 'rails', d: 'sqlite3', G: true, 'G' => true, 'skip-git' => true, :'skip-git' => true}
        end

        it 'calls Rails new with the --skip-git flag' do
          expect_any_instance_of(Flatcar::Project).to receive(:system).with('rails new -B app_name --skip-git')
          Flatcar::Project.new(options, args)
        end
      end

      context '--skip-keeps' do
        let(:options) do
          { b: 'rails', d: 'sqlite3', 'skip-keeps' => true, :'skip-keeps' => true}
        end

        it 'calls Rails new with the --skip-keeps flag' do
          expect_any_instance_of(Flatcar::Project).to receive(:system).with('rails new -B app_name --skip-keeps')
          Flatcar::Project.new(options, args)
        end
      end

      context '--skip-active-record' do
        let(:options) do
          { b: 'rails', d: 'sqlite3', O: true, 'O' => true, 'skip-active-record' => true, :'skip-active-record' => true}
        end

        it 'calls Rails new with the --skip-active-record flag' do
          expect_any_instance_of(Flatcar::Project).to receive(:system).with('rails new -B app_name --skip-active-record')
          Flatcar::Project.new(options, args)
        end
      end

      context '--skip-action-view' do
        let(:options) do
          { b: 'rails', d: 'sqlite3', V: true, 'V' => true, 'skip-action-view' => true, :'skip-action-view' => true}
        end

        it 'calls Rails new with the --skip-action-view flag' do
          expect_any_instance_of(Flatcar::Project).to receive(:system).with('rails new -B app_name --skip-action-view')
          Flatcar::Project.new(options, args)
        end
      end

      context '--skip-sprockets' do
        let(:options) do
          { b: 'rails', d: 'sqlite3', S: true, 'S' => true, 'skip-sprockets' => true, :'skip-sprockets' => true}
        end

        it 'calls Rails new with the --skip-sprockets flag' do
          expect_any_instance_of(Flatcar::Project).to receive(:system).with('rails new -B app_name --skip-sprockets')
          Flatcar::Project.new(options, args)
        end
      end

      context '--skip-spring' do
        let(:options) do
          { b: 'rails', d: 'sqlite3', 'skip-spring' => true, :'skip-spring' => true}
        end

        it 'calls Rails new with the --skip-spring flag' do
          expect_any_instance_of(Flatcar::Project).to receive(:system).with('rails new -B app_name --skip-spring')
          Flatcar::Project.new(options, args)
        end
      end

      context '--skip-test-unit' do
        let(:options) do
          { b: 'rails', d: 'sqlite3', T: true, 'T' => true, 'skip-test-unit' => true, :'skip-test-unit' => true}
        end

        it 'calls Rails new with the --skip-test-unit flag' do
          expect_any_instance_of(Flatcar::Project).to receive(:system).with('rails new -B app_name --skip-test-unit')
          Flatcar::Project.new(options, args)
        end
      end

      context '--skip-javascript' do
        let(:options) do
          { b: 'rails', d: 'sqlite3', J: true, 'J' => true, 'skip-javascript' => true, :'skip-javascript' => true}
        end

        it 'calls Rails new with the --skip-javascript flag' do
          expect_any_instance_of(Flatcar::Project).to receive(:system).with('rails new -B app_name --skip-javascript')
          Flatcar::Project.new(options, args)
        end
      end

      context '--dev' do
        let(:options) do
          { b: 'rails', d: 'sqlite3', 'dev' => true, :'dev' => true}
        end

        it 'calls Rails new with the --dev flag' do
          expect_any_instance_of(Flatcar::Project).to receive(:system).with('rails new -B app_name --dev')
          Flatcar::Project.new(options, args)
        end
      end

      context '--edge' do
        let(:options) do
          { b: 'rails', d: 'sqlite3', 'edge' => true, :'edge' => true}
        end

        it 'calls Rails new with the --edge flag' do
          expect_any_instance_of(Flatcar::Project).to receive(:system).with('rails new -B app_name --edge')
          Flatcar::Project.new(options, args)
        end
      end

      context '--javascript' do
        let(:options) do
          { b: 'rails', d: 'sqlite3', j: 'react', 'j' => 'react', 'javascript' => 'react', :'javascript' => 'react'}
        end

        it 'calls Rails new with the --javascript flag' do
          expect_any_instance_of(Flatcar::Project).to receive(:system).with('rails new -B app_name --javascript=react')
          Flatcar::Project.new(options, args)
        end
      end

      context '--template' do
        let(:options) do
          { b: 'rails', d: 'sqlite3', m: 'foo', 'm' => 'foo', 'template' => 'foo', :'template' => 'foo'}
        end

        it 'calls Rails new with the --template flag' do
          expect_any_instance_of(Flatcar::Project).to receive(:system).with('rails new -B app_name --template=foo')
          Flatcar::Project.new(options, args)
        end
      end

      context 'multiple options' do
        let(:options) do
          {
            b: 'rails',
            d: 'sqlite3',
            m: 'foo',
            'm' => 'foo',
            'template' => 'foo',
            :'template' => 'foo',
            J: true,
            'J' => true,
            'skip-javascript' => true,
            :'skip-javascript' => true
          }
        end

        it 'calls Rails new with each option' do
          expect_any_instance_of(Flatcar::Project)
            .to receive(:system).with('rails new -B app_name --skip-javascript --template=foo')
          Flatcar::Project.new(options, args)
        end
      end
    end
  end

  describe '#app_path' do
    before do
      allow(Flatcar::Service).to receive(:instance).with('sqlite3')
      allow(Flatcar::Service).to receive(:instance).with('webapp', base_image: 'rails', database: nil)
    end

    context 'if no path is given' do
      subject { Flatcar::Project.new(default_options, []) }

      it 'returns . if no path is given' do
        expect(subject.app_path).to eq '.'
      end
    end

    context 'when a path is given to .initialize' do
      subject { Flatcar::Project.new(default_options, args) }

      it 'returns the path' do
        expect(subject.app_path).to eq 'app_name'
      end
    end
  end

  describe '#project_path' do
    before do
      allow(Flatcar::Service).to receive(:instance).with('sqlite3')
      allow(Flatcar::Service).to receive(:instance).with('webapp', base_image: 'rails', database: nil)
    end

    context 'if no path is given' do
      subject { Flatcar::Project.new(default_options, []) }

      it 'returns the current working directory' do
        expect(subject.project_path).to eq Dir.pwd
      end
    end

    context 'when a path is given' do
      subject { Flatcar::Project.new(default_options, args) }

      it 'returns the current working directory with the path appended' do
        expect(subject.project_path).to eq "#{Dir.pwd}/app_name"
      end
    end
  end

  describe '#project_name' do
    before do
      allow(Flatcar::Service).to receive(:instance).with('sqlite3')
      allow(Flatcar::Service).to receive(:instance).with('webapp', base_image: 'rails', database: nil)
    end

    context 'if no path is given' do
      subject { Flatcar::Project.new(default_options, []) }

      it 'returns the basename of the current working directory' do
        expect(subject.project_name).to eq File.basename(Dir.pwd)
      end
    end

    context 'when a path is given' do
      subject { Flatcar::Project.new(default_options, args) }

      it 'returns the path' do
        expect(subject.project_name).to eq 'app_name'
      end
    end
  end

  describe '#write_dockerfile' do
    let(:io) { StringIO.new }

    before do
      allow(Flatcar::Service).to receive(:instance).with('sqlite3')
      allow(Flatcar::Service)
        .to receive(:instance).with('webapp', base_image: 'rails', database: nil).and_return(webapp)
      allow(File).to receive(:open).and_yield(io)
    end

    subject { Flatcar::Project.new(default_options, []) }

    it 'writes to the Dockerfile in the app path' do
      expect(File).to receive(:open).with('./Dockerfile', 'w')
      subject.write_dockerfile
    end

    it 'writes the webapp dockerfile representation' do
      expect(io).to receive(:write).with(webapp.dockerfile)
      subject.write_dockerfile
    end
  end

  describe '#write_compose_yaml' do
    let(:io) { StringIO.new }

    before do
      allow(File).to receive(:open).and_yield(io)
    end

    context 'when there is a database service' do
      let(:db_service_hash) { { 'bar' => 'baz' } }
      let(:database) { double('database_service', name: 'postgresql', to_h: db_service_hash) }

      before do
        allow(Flatcar::Service).to receive(:instance).with('postgresql').and_return(database)
        allow(Flatcar::Service)
          .to receive(:instance).with('webapp', base_image: 'rails', database: database).and_return(webapp)
      end

      subject { Flatcar::Project.new({ b: 'rails', d: 'postgresql' }, []) }

      it 'writes to the docker-compose.yml file in the app path' do
        expect(File).to receive(:open).with('./docker-compose.yml', 'w')
        subject.write_compose_yaml
      end

      it 'writes the compose representation for all services' do
        expect(io).to receive(:write).with("---\nfoo: bar\nbar: baz\n")
        subject.write_compose_yaml
      end
    end

    context 'without a database service' do
      before do
        allow(Flatcar::Service).to receive(:instance).with('sqlite3')
        allow(Flatcar::Service)
          .to receive(:instance).with('webapp', base_image: 'rails', database: nil).and_return(webapp)
      end

      subject { Flatcar::Project.new(default_options, []) }

      it 'writes to the docker-compose.yml file in the app path' do
        expect(File).to receive(:open).with('./docker-compose.yml', 'w')
        subject.write_compose_yaml
      end

      it 'writes the compose representation for the webapp' do
        expect(io).to receive(:write).with("---\nfoo: bar\n")
        subject.write_compose_yaml
      end
    end
  end

  describe '#docker_build' do
    before do
      allow(Flatcar::Service).to receive(:instance).with('sqlite3')
      allow(Flatcar::Service).to receive(:instance).with('webapp', base_image: 'rails', database: nil)
    end

    context 'if no path is given' do
      subject { Flatcar::Project.new(default_options, []) }

      it 'calls docker-compose build in the current directory' do
        expect(subject).to receive(:system).with("cd ./ && docker-compose build")
        subject.send(:docker_build)
      end
    end

    context 'when a path is given' do
      subject { Flatcar::Project.new(default_options, args) }

      it 'calls docker-compose build in the app path' do
        expect(subject).to receive(:system).with("cd app_name/ && docker-compose build")
        subject.send(:docker_build)
      end
    end
  end
end
