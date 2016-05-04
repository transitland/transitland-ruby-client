describe TransitlandClient::Feed do
  context 'individual' do
    it 'can be initialized from a JSON file, by providing the appropriate Onestop ID' do
      VCR.use_cassette("test", :record => :new_episodes) do
        feed = TransitlandClient::Feed.find_by(onestop_id: 'f-9q9-caltrain').first
        expect(feed.get(:onestop_id)).to eq 'f-9q9-caltrain'
        expect(feed.get(:feed_format)).to eq 'gtfs'
        expect(feed.get(:url)).to eq 'http://www.caltrain.com/Assets/GTFS/caltrain/GTFS-Caltrain-Devs.zip'
      end
    end

    it 'will cleanly fail when no Onestop ID or JSON blob provided' do
      expect {
        TransitlandClient::Feed.new(nil)
      }.to raise_error(TransitlandClient::EntityException)
    end
    
    it 'will return an array of its attributes' do
      VCR.use_cassette("test") do
        expect(TransitlandClient::Feed.find_by(onestop_id: 'f-9q9-caltrain').first.get_attributes).to be_a Array
        expect(TransitlandClient::Feed.find_by(onestop_id: 'f-9q9-caltrain').first.get_attributes.first).to be_a Symbol
      end
    end
    
    it 'will cleanly fail when an invalid key is provided' do
      expect {
        TransitlandClient::Feed.find_by(onestop_id: 'f-9q9-caltrain').first.get(:location)
      }.to raise_error(TransitlandClient::EntityException)
    end

    it 'will cleanly fail when no JSON file found to go with provided Onestop ID' do
      VCR.use_cassette("test", :record => :new_episodes) do
        expect {
          TransitlandClient::Feed.find_by(onestop_id: 'f-9q9-NoBART').first
        }.to raise_error(TransitlandClient::ApiException)
      end
    end
  end

  context 'find_by' do
    it 'feed Onestop ID' do
      VCR.use_cassette("test") do
        expect(TransitlandClient::Feed.find_by(onestop_id: 'f-9q9-caltrain').first).to be_a TransitlandClient::Feed
      end
    end

    it 'fails gracefully' do
      expect {
        TransitlandClient::Feed.find_by
      }.to raise_error(ArgumentError)
    end
  end
end
