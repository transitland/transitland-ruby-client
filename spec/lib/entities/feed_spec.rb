describe TransitlandClient::Feed do
  context 'individual' do
    it 'can be initialized from a JSON file, by providing the appropriate Onestop ID' do
      VCR.use_cassette("test", :record => :new_episodes) do
        feed = TransitlandClient::Feed.find_by(onestop_id: 'f-9q9-caltrain')
        expect(feed.onestop_id).to eq 'f-9q9-caltrain'
        expect(feed.feed_format).to eq 'gtfs'
        expect(feed.url).to eq 'http://www.caltrain.com/Assets/GTFS/caltrain/GTFS-Caltrain-Devs.zip'
      end
    end

    it 'will cleanly fail when no Onestop ID or JSON blob provided' do
      expect {
        TransitlandClient::Feed.new()
      }.to raise_error(ArgumentError)
    end

    it 'will cleanly fail when no JSON file found to go with provided Onestop ID' do
      pending
      expect {
        TransitlandClient::Feed.new(onestop_id: 'f-9q9-NoBART')
      }.to raise_error(ArgumentError, 'no JSON file found with a Onestop ID of f-9q9-NoBART')
    end

    it 'has associated OperatorInFeed entities' do
      pending
      feed = TransitlandClient::Feed.new(onestop_id: 'f-9q9-bayarearapidtransit')
      expect(feed.operators_in_feed.count).to eq 1
      expect(feed.operators_in_feed.first.gtfs_agency_id).to eq 'BART'
      expect(feed.operators_in_feed.first.operator_onestop_id).to eq 'o-9q9-bayarearapidtransit'
    end
  end

  context 'find_by' do
    it 'feed Onestop ID' do
      VCR.use_cassette("test") do
        expect(TransitlandClient::Feed.find_by(onestop_id: 'f-9q9-caltrain')).to be_a TransitlandClient::Feed
      end
    end

    it 'operator Onestop ID' do
      pending
      expect(TransitlandClient::Feed.find_by(onestop_id: 'o-9q9-bayarearapidtransit').first).to be_a TransitlandClient::Feed
    end

    it 'operator identifier' do
      pending
      expect(TransitlandClient::Feed.find_by(operator_identifier: 'usntd://9014').first).to be_a TransitlandClient::Feed
    end

    it 'tag key and value' do
      pending
      found_feed = TransitlandClient::Feed.find_by(tag_key: 'license', tag_value: 'Creative Commons Attribution 3.0 Unported License').first
      expected_feed = TransitlandClient::Feed.find_by(onestop_id: 'f-9q9-actransit')

      expect(found_feed.onestop_id).to eq expected_feed.onestop_id
      expect(found_feed.url).to eq expected_feed.url
    end

    it 'fails gracefully' do
      expect {
        TransitlandClient::Feed.find_by
      }.to raise_error(ArgumentError)
    end
  end
end
