# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :mentions_as_mentioner, class_name: 'Mention', dependent: :destroy, foreign_key: 'mention_report_id', inverse_of: :mention_report
  has_many :mentions_as_mentioned, class_name: 'Mention', dependent: :destroy, foreign_key: 'mentioned_report_id', inverse_of: :mentioned_report
  has_many :mention_reports, through: :mentions_as_mentioner
  has_many :mentioned_reports, through: :mentions_as_mentioned

  validates :title, presence: true
  validates :content, presence: true

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end
end
