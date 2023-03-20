# frozen_string_literal: true

require 'uri'
require 'debug'
class ReportsController < ApplicationController
  before_action :set_report, only: %i[edit update destroy]

  def index
    @reports = Report.includes(:user).order(id: :desc).page(params[:page])
  end

  def show
    @report = Report.find(params[:id])
    @mention_reports = @report.mentioned_reports
  end

  # GET /reports/new
  def new
    @report = current_user.reports.new
  end

  def edit; end

  def create
    @report = current_user.reports.new(report_params)

    result = save_report_and_mention(:create)
    if result
      redirect_to @report, notice: t('controllers.common.notice_create', name: Report.model_name.human)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    result = save_report_and_mention(:update)
    if result
      redirect_to @report, notice: t('controllers.common.notice_update', name: Report.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @report.destroy

    redirect_to reports_url, notice: t('controllers.common.notice_destroy', name: Report.model_name.human)
  end

  private

  def set_report
    @report = current_user.reports.find(params[:id])
  end

  def report_params
    params.require(:report).permit(:title, :content)
  end

  def create_mentions(mention_id_list)
    mention_id_list.uniq.each do |mention_id|
      if Report.exists?(id: mention_id.to_i) && mention_id.to_i != @report.id
        Mention.create(mention_report: @report, mentioned_report: Report.find(mention_id.to_i))
      end
    end
  end

  def destroy_mentions(mentioning_list)
    mentioning_list.each(&:destroy)
  end

  def save_report_and_mention(control)
    mentioning_list = @report.mentions_as_mentioner
    mention_id_list = report_params[:content].scan(%r{(?<=http://localhost:3000/reports/)\d+})
    @report.transaction do
      case control
      when :create
        @report.save!
      when :update
        @report.update(report_params)
      end
      destroy_mentions(mentioning_list)
      create_mentions(mention_id_list)
    end
  end
end
