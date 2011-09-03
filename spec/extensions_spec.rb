require 'spec_helper'

describe Ayl::Extensions do

  class ExtendedClass
    include Ayl::Extensions
  end

  context "Send methods" do

    before(:each) do
      @cut = ExtendedClass.new
    end

    it "should delegate the call to ayl_send to ayl_send_opts" do
      @cut.should_receive(:ayl_send_opts).with(:something, {}, "arg1", "arg2")
      @cut.ayl_send(:something, "arg1", "arg2")
    end

    it "should have the message submit the call from ayl_send_opts" do
      mock_message_opts = mock("Ayl::MessageOptions")
      Ayl::MessageOptions.should_receive(:new).with({}).and_return(mock_message_opts)
      
      mock_message = mock("Ayl::Message")
      mock_message.should_receive(:submit)

      Ayl::Message.should_receive(:new).with(@cut, :something, mock_message_opts, "arg1", "arg2").and_return(mock_message)

      @cut.ayl_send_opts(:something, {}, "arg1", "arg2")
    end

  end

end