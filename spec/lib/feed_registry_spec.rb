describe TransitlandClient::FeedRegistry do
  context 'repo' do
    it 'will fetch the repo the repo the first time, pull the second' do
      expect(TransitlandClient::FeedRegistry.repo).to be_a Git::Base
      expect(TransitlandClient::FeedRegistry.repo).to be_a Git::Base
    end
  end
end
