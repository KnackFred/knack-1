require "spec_helper"

describe Venmo do
  it "let's us know the current user is authorized if we have the access token" do
    Venmo.new(:venmo_access_token => 'the access token').should be_authorized
  end

  it "let's us know the current user is not authorized if we don't have the access token" do
    Venmo.new.should_not be_authorized
  end

  describe '#store_access_token' do
    it "stores the access token for later use" do
      venmo = Venmo.new
      venmo.store_access_token('access token')
      venmo.should be_authorized
    end

    it "does nothing if the access token is not being passed in" do
      venmo = Venmo.new(:venmo_access_token => 'current access token')
      venmo.store_access_token('')
      venmo.should be_authorized
    end
  end

  describe 'making payments' do
    it "does the transfer on venmo" do
      venmo = Venmo.new(:venmo_access_token => 'current access token')
      wrest_uri = mock('Wrest::Uri')
      Wrest::Uri.should_receive(:new).with("#{venmo.venmo_url}/payments?email=registrant%40email.com&amount=1000&note=Congratulations", {}).and_return(wrest_uri)
      wrest_uri.should_receive(:post).with(:access_token => 'current access token', :follow_redirects => true).and_return(mock('response', :ok? => true))
      venmo.make_payment('1000', 'registrant@email.com', 'Congratulations')
    end

    it "raises an error if there's an issue with the payment" do
      venmo = Venmo.new(:venmo_access_token => 'current access token')
      wrest_uri = mock('Wrest::Uri')
      Wrest::Uri.should_receive(:new).with("#{venmo.venmo_url}/payments?email=registrant%40email.com&amount=1000&note=Congratulations", {}).and_return(wrest_uri)
      wrest_uri.should_receive(:post).with(:access_token => 'current access token', :follow_redirects => true).and_return(mock('response', :ok? => false, :body => 'Error body'))
      lambda {
        venmo.make_payment('1000', 'registrant@email.com', 'Congratulations')
      }.should raise_error(VenmoError)
    end
  end
end
