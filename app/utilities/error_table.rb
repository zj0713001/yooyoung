class ErrorTable
  include Singleton

  TABLE = {
    "ActiveRecord::RecordNotFound" => {
      error_code: 1,
      message: I18n.t('error_table.record_not_found')
    },
    "Mongoid::Errors::DocumentNotFound" => {
      error_code: 1,
      message: I18n.t('error_table.record_not_found')
    },
    "Timeout::Error" => {
      error_code: 2,
      message: I18n.t('error_table.timeout')
    },
    "RuntimeError" => {
      error_code: 3,
      message: I18n.t('error_table.runtime_error')
    },
    "CanCan::AccessDenied" => {
      error_code: 4,
      message: I18n.t('error_table.access_denied')
    },
    "YooYoung::CreateError" => {
      error_code: 5,
      message: I18n.t('error_table.create_error')
    },
    "YooYoung::DuplicateCreatedError" => {
      error_code: 6,
      message: I18n.t('error_table.duplicate_create_error')
    },
    "YooYoung::UpdateError" => {
      error_code: 7,
      message: I18n.t('error_table.update_error')
    },
    "YooYoung::DeleteError" => {
      error_code: 8,
      message: I18n.t('error_table.delete_error')
    },
    "YooYoung::TryTooManyTimesError" => {
      error_code: 9,
      message: I18n.t('error_table.try_too_many_times')
    },
    "YooYoung::IncorrectArguments" => {
      error_code: 10,
      message: I18n.t('error_table.incorrect_arguments')
    },
  }

  def handle(error_class)
    (TABLE[error_class.to_s] || TABLE["RuntimeError"]).merge(status: false)
  end
end
