require 'rails_helper'

RSpec.describe Response do
  describe ".success" do
    it "Should create a new response with valid attr equal to true" do
      response = Response.success
      expect(response.valid).to be_truthy
      expect(response.errors).to be_empty
      expect(response.warnings).to be_empty
      expect(response.data).to be_empty
    end
  end

  describe ".error" do
    it "Should create a new response with valid attr equal to true" do
      response = Response.error(:error_1, :error_2)
      expect(response.valid).to be_falsey
      expect(response.errors).to match_array([:error_1, :error_2])
      expect(response.warnings).to be_empty
      expect(response.data).to be_empty
    end
  end

  describe "#success?" do
    context "Valid is true" do
      it "Should return true" do
        response = Response.success
        expect(response.success?).to be_truthy
      end
    end
    context "Valid is false" do
      it "Should return false" do
        response = Response.error(:error_1)
        expect(response.success?).to be_falsey
      end
    end
  end

  describe "#error?" do
    context "Valid is true" do
      it "Should return false" do
        response = Response.success
        expect(response.error?).to be_falsey
      end
    end
    context "Valid is false" do
      it "Should return false" do
        response = Response.error(:error_1)
        expect(response.error?).to be_truthy
      end
    end
  end

  describe "#parsed_errors" do
    context "With a block given" do
      it "Should yield" do
        response = Response.error(:an_error) { |errors| errors.map(&:to_s) }
        expect(response.parsed_errors).to eq(["an_error"])
      end
    end
    context "Without a block given" do
      it "Should return the errors" do
        response = Response.error(:an_error)
        expect(response.parsed_errors).to eq([:an_error])
      end
    end
  end
end
