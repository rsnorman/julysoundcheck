class ErrorLogger
  def self.log(*args)
    new.send(:log, *args)
  end

  private

  def log(*args)
    raise args.first unless Rails.env.production?
    @error_client.error(*args)
  end

  def initialize(error_client = Rollbar)
    @error_client = Rollbar
  end
end
