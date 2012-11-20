require 'spec_helper'

class StubUser
  def credentials
    json = Oj.load File.read File.expand_path('../credentials.json', __FILE__)
    Hash[ json.map {|k,v| [k.to_sym,v]} ]
  end
end

describe Finch do

  before :each do
    @finch = Finch[StubUser.new]
  end

  it 'can search twitter' do
    @finch.get('search/tweets', :q => 'ruby').should be_an_instance_of Hash
    @finch.response_status.should be 200
  end

  it 'processes rate limits' do
    called = false
    @finch.rate_limit do |remaining, total, user|
      called = true
      total.should equal 180
      remaining.should be < total
    end

    @finch.get('search/tweets', :q => 'ruby')
    called.should be true
  end

end