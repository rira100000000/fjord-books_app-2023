# frozen_string_literal: true

class Mention < ApplicationRecord
  belongs_to :mention_report, class_name: 'Report', inverse_of: :mentions_as_mentioner
  belongs_to :mentioned_report, class_name: 'Report', inverse_of: :mentions_as_mentioned
end
