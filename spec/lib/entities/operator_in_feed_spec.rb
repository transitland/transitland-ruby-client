describe TransitlandClient::OperatorInFeed do
  it 'can be created from the feed side' do
    feed = TransitlandClient::Feed.new(onestop_id: 'f-9q9-bayarearapidtransit')
    expect(feed.operators_in_feed.count).to eq 1
    expect(feed.operators_in_feed.first.gtfs_agency_id).to eq 'BART'
    expect(feed.operators_in_feed.first.operator_onestop_id).to eq 'o-9q9-bayarearapidtransit'
  end

  it 'fails gracefully when not enough arguments provided' do
    expect {
      TransitlandClient::OperatorInFeed.new()
    }.to raise_error(ArgumentError)

    expect {
      TransitlandClient::OperatorInFeed.new(feed_onestop_id: 'f-9q9-wrong')
    }.to raise_error(ArgumentError)

    expect {
      TransitlandClient::OperatorInFeed.new(operator_onestop_id: 'o-9q9-bayarearapidtransit')
    }.to raise_error(ArgumentError)
  end
end
