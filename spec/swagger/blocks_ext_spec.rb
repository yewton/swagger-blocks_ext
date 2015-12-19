require 'spec_helper'

describe Swagger::BlocksExt do
  before :each do
    stub_const 'Root', Class.new {
      include Swagger::Blocks
      using Swagger::BlocksExt::NodeExt
      swagger_root do
        key :swagger, '2.0'
        info do
          key :version, '0.0.1'
          key :title, 'Swagger Petstore'
          key :description, 'Swagger Petstore'
        end
        key :host, 'petstore.swagger.wordnik.com'
        key :basePath, '/api'
        key :schemes, ['http']
        key :consumes, ['application/json']
        key :produces, ['application/json']
      end
    }

    stub_const 'Paths', Class.new {
      include Swagger::Blocks
      using Swagger::BlocksExt::NodeExt
      swagger_path '/pets' do
        operation :get do
          key :description, 'Returns all pets from the system that the user has access to.'
          parameter do
            key :name, :tags
            key :in, :query
            key :description, 'tags to filter by'
            key :required, false
            key :type, :array
            items do
              key :type, :string
            end
            key :collectionFormat, :csv
          end
          response 200 do
            key :description, 'pet response'
            schema do
              key :type, :array
              items do
                key :'$ref', :Pet
              end
            end
          end
        end
      end
    }
  end

  it 'has a version number' do
    expect(Swagger::BlocksExt::VERSION).not_to be nil
  end

  describe '#to_json' do
    let(:expected) {
      %({"swagger":"2.0","info":{"version":"0.0.1","title":"Swagger Petstore","description":"Swagger Petstore"},"host":"petstore.swagger.wordnik.com","basePath":"/api","schemes":["http"],"consumes":["application/json"],"produces":["application/json"],"paths":{"/pets":{"get":{"description":"Returns all pets from the system that the user has access to.","parameters":[{"name":"tags","in":"query","description":"tags to filter by","required":false,"type":"array","items":{"type":"string"},"collectionFormat":"csv"}],"responses":{"200":{"description":"pet response","schema":{"type":"array","items":{"$ref":"#/definitions/Pet"}}}}}}}})
    }
    subject { Swagger::BlocksExt.to_json }
    it { expect(subject).to eq(expected) }
  end

  describe "#to_yaml" do
    let(:expected) {
<<EOS
---
swagger: '2.0'
info:
  version: 0.0.1
  title: Swagger Petstore
  description: Swagger Petstore
host: petstore.swagger.wordnik.com
basePath: "/api"
schemes:
- http
consumes:
- application/json
produces:
- application/json
paths:
  "/pets":
    get:
      description: Returns all pets from the system that the user has access to.
      parameters:
      - name: tags
        in: query
        description: tags to filter by
        required: false
        type: array
        items:
          type: string
        collectionFormat: csv
      responses:
        '200':
          description: pet response
          schema:
            type: array
            items:
              "$ref": "#/definitions/Pet"
EOS
    }
    subject { Swagger::BlocksExt.to_yaml }
    it { expect(subject).to eq(expected) }
  end

  context 'description support' do
    let (:node) {
      raise "`descriptions_path' is not configured. Swagger::BlocksExt.configure first."
    }
    context 'when not configured descriptions_path' do
      it 'raises an error'do
        expect {
          Class.new {
            include Swagger::Blocks
            using Swagger::BlocksExt::NodeExt

            swagger_path '/pets/{id}' do
              operation :get do
                key :description, md('paths_post_pets')
              end
            end
          }
        }.to raise_error("`descriptions_path' is not configured. Swagger::BlocksExt.configure first.")
      end
    end
    context 'when configured descriptions_path' do
      let (:configuration) {
        Swagger::BlocksExt::Configuration.new.tap {|c|
          c.descriptions_path = __dir__
        }
      }
      before :each do
        allow(Swagger::BlocksExt).to receive(:configuration).and_return(configuration)
        stub_const 'PetPaths', Class.new {
          include Swagger::Blocks
          using Swagger::BlocksExt::NodeExt

          swagger_path '/pets/{id}' do
            operation :get do
              key :description, md('pets_id_get')
              parameter do
                key :name, :id
                key :in, :path
                key :description, 'ID of pet to fetch'
                key :required, true
                key :type, :integer
                key :format, :int64
              end
              response 200 do
                key :description, 'pet response'
              end
            end
          end
        }
      end
      subject { Swagger::BlocksExt.to_hash[:paths][:'/pets/{id}'][:get][:description] }
      it 'can set a description with a file' do
        expect(subject).to eq('Returns a user based on a single ID, if the user does not have access to the pet')
      end
    end
  end
end
