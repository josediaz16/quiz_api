class Response
  attr_reader :valid, :errors, :warnings, :data

  delegate :inspect, :to_s, to: :response

  def self.success(data: {})
    self.new(valid: true, data: data)
  end

  def self.error(*errors, &block)
    self.new(valid: false, errors: errors, &block)
  end

  def success?
    valid
  end

  def error?
    not valid
  end

  def ==(value)
    eql?(value)
  end

  def eql?(value)
    if value.class.eql?(Response)
      value.response.eql?(response)
    else
      false
    end
  end

  def parsed_errors
    if @block.present?
      @block.call(errors)
    else
      errors
    end
  end

  def response
    {valid: valid, errors: errors, warnings: warnings, data: data}
  end

  private

  def initialize(valid:, errors: [], warnings: [], data: {}, &block)
    @valid, @errors, @warnings, @data, @block = valid, errors, warnings, data, block
  end
end
