# frozen_string_literal: true

module ReportsHelper
  def report_author?(report)
    current_user.id == report.user_id
  end
end
