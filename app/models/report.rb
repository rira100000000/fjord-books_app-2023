# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :mentions_as_mentioner, class_name: 'Mention', dependent: :destroy, foreign_key: 'mention_report_id', inverse_of: :mention_report
  has_many :mentions_as_mentioned, class_name: 'Mention', dependent: :destroy, foreign_key: 'mentioned_report_id', inverse_of: :mentioned_report
  has_many :mentioning_reports, through: :mentions_as_mentioner, source: :mentioned_report
  has_many :mentioned_reports, through: :mentions_as_mentioned, source: :mention_report

  validates :title, presence: true
  validates :content, presence: true

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

  def save_report_and_mention(report_params)
    assign_attributes({ title: report_params[:title], content: report_params[:content] })
    transaction do
      save!
      destroy_mentions
      create_mentions
    end
  end

  def create_mentions
    mention_id_list = content.scan(%r{(?<=http://localhost:3000/reports/)\d+})

    mention_id_list.uniq.each do |mention_id|
      Mention.create(mention_report: self, mentioned_report: Report.find(mention_id.to_i)) if Report.exists?(id: mention_id.to_i) && mention_id.to_i != id
    end
  end

  def destroy_mentions
    mentioning_list = mentions_as_mentioner
    mentioning_list.each(&:destroy)
  end
end
