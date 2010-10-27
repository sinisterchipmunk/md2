require 'spec_helper'

describe MD2::Header do
  context "with invalid content" do
    subject { MD2::Header.new(mock_io("this is invalid "*10)) }
    
    it "should raise MD2::Errors::InvalidFile" do
      proc { subject }.should raise_error(MD2::Errors::InvalidFile)
    end
  end
  
  context "with valid ID" do
    context "and invalid version" do
      subject { MD2::Header.new(mock_io("IDP2" + ("this is invalid"*10))) }
      
      it "should raise MD2::Errors::InvalidVersion" do
        proc { subject }.should raise_error(MD2::Errors::InvalidVersion)
      end
    end
  end
end