class YooYoung
  class CreateError < StandardError; end
  class DuplicateCreatedError < StandardError; end
  class UpdateError < StandardError; end
  class DeleteError < StandardError; end
  class TryTooManyTimesError < StandardError; end
  class IncorrectArguments < StandardError; end
  class VerificationFailure < StandardError; end
  class BrowserTooLow < StandardError; end
end
