# frozen_string_literal: true

require 'spec_helper'

describe 'postgresql::server::contrib', type: :class do
  let :pre_condition do
    "class { 'postgresql::server': }"
  end

  let :facts do
    {
      os: {
        family: 'RedHat',
        name: 'RedHat',
        release: { 'major' => '8' },
        selinux: {
          enabled: false,
        },
      },
      kernel: 'Linux',
      id: 'root',
      path: '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    }
  end

  describe 'with parameters' do
    let(:params) do
      {
        package_name: 'mypackage',
        package_ensure: 'absent',
      }
    end

    it 'creates package with correct params' do
      is_expected.to contain_package('postgresql-contrib').with(ensure: 'absent',
                                                                name: 'mypackage',
                                                                tag: 'puppetlabs-postgresql')
    end
  end

  describe 'with no parameters' do
    it 'creates package with postgresql tag' do
      is_expected.to contain_package('postgresql-contrib').with(tag: 'puppetlabs-postgresql')
    end
  end
end
