describe TransitlandClient::BoundingBox do
  context 'initializes as an object' do
    it 'from a string' do
      bbox = TransitlandClient::BoundingBox.new('1,2,3,4')
      expect(bbox.coordinates).to match_array([1,2,3,4])
      expect { TransitlandClient::BoundingBox.new('string') }.to raise_error(ArgumentError)
      expect { TransitlandClient::BoundingBox.new('1,1,1') }.to raise_error(ArgumentError)
      expect { TransitlandClient::BoundingBox.new('1,1,1,') }.to raise_error(ArgumentError)
    end
  end
end
