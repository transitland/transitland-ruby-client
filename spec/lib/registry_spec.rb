describe OnestopIdClient::Registry do
  context 'repo' do
    it 'will fetch the repo the repo the first time, pull the second' do
      expect(OnestopIdClient::Registry.repo).to be_a Git::Base
      expect(OnestopIdClient::Registry.repo).to be_a Git::Base
    end
  end
end
