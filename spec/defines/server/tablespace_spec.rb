# frozen_string_literal: true

require 'spec_helper'

describe 'postgresql::server::tablespace' do
  include_examples 'Debian 11'

  let :title do
    'test'
  end

  let :params do
    {
      location: '/srv/data/foo',
    }
  end

  let :pre_condition do
    "class {'postgresql::server':}"
  end

  it { is_expected.to contain_file('/srv/data/foo').with_ensure('directory') }
  it { is_expected.to contain_postgresql__server__tablespace('test') }
  it { is_expected.to contain_postgresql_psql('CREATE TABLESPACE "test"').that_requires('Service[postgresqld]') }

  context 'with different owner' do
    let :params do
      {
        location: '/srv/data/foo',
        owner: 'test_owner',
      }
    end

    it { is_expected.to contain_postgresql_psql('ALTER TABLESPACE "test" OWNER TO "test_owner"') }
  end

  context 'with manage_location set to false' do
    let :params do
      {
        location: '/srv/data/foo',
        manage_location: false,
      }
    end

    let :pre_condition do
      "
      class {'postgresql::server':}
      file {'/srv/data/foo': ensure => 'directory'}
      "
    end

    it { is_expected.to contain_file('/srv/data/foo').with_ensure('directory') }
  end
end
