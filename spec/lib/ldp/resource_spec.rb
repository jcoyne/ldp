require 'spec_helper'

describe Ldp::Resource do
  subject { Ldp::Resource.new(mock_client, path) }

  let(:conn_stubs) do
    stubs = Faraday::Adapter::Test::Stubs.new do |stub|
      stub.get('/not_found_resource') { [404] }
      stub.get('/a_resource') { [200] }
    end
  end

  let(:mock_conn) do
    test = Faraday.new do |builder|
      builder.adapter :test, conn_stubs do |stub|
      end
    end
  end

  let :mock_client do
    Ldp::Client.new mock_conn
  end

  describe "#get" do
    context "when the resource is not in repository" do
      let(:path) { '/not_found_resource' }
      it "should raise an error" do
        expect{ subject.get }.to raise_error Ldp::NotFound
      end
    end

    context "when the resource is in the repository" do
      let(:path) { '/a_resource' }
      it "should get the response" do
        expect(subject.get).to be_kind_of Faraday::Response
        expect(subject.get.status).to eq 200
      end
    end
  end
end
