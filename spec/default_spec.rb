require 'chefspec'
require 'chefspec/berkshelf'

describe 'yum-corporate::default' do
  context 'yum-corporate::default on domain marshall.edu' do
    let(:chef_run) do
      ChefSpec::Runner.new(platform: 'centos', version: 6.4, step_into: ['yum_repository']) do |node|
        node.automatic['domain'] = 'example.com'
        node.set['yum']['corporate']['gpgkey'] = nil
      end.converge(described_recipe)
    end

    it 'renders template[/etc/yum.repos.d/example.com] with baseurl' do
      expect(chef_run).to render_file('/etc/yum.repos.d/example.repo').with_content('baseurl=http://yum.example.com/yum/rhel/6/$basearch')
    end

    it 'renders tempate[/etc/yum.repos.d/marshall.repo] without gpgcheck' do
      expect(chef_run).to render_file('/etc/yum.repos.d/example.repo').with_content('gpgcheck=0')
    end
  end

  context 'gpgkey is set to http://yum.example.com/yum/RPM-GPG-KEY-marshall' do
    let(:chef_run) do
      ChefSpec::Runner.new(step_into: ['yum_repository']) do |node|
        node.automatic['domain'] = 'example.com'
        node.set['yum']['corporate']['gpgkey'] = 'http://yum.example.com/yum/RPM-GPG-KEY-marshall'
      end.converge(described_recipe)
    end

    it 'renders tempate[/etc/yum.repos.d/example.repo] without gpgcheck' do
      expect(chef_run).to render_file('/etc/yum.repos.d/example.repo').with_content('gpgcheck=1')
    end
  end
end
