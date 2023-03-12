# frozen_string_literal: true

require 'uri'

class ReportsController < ApplicationController
  before_action :set_report, only: %i[edit update destroy]
  helper_method :add_a_tag

  def index
    @reports = Report.includes(:user).order(id: :desc).page(params[:page])
  end

  def show
    @report = Report.find(params[:id])
    mention_list = @report.mentioned_reports
    @mention_reports = mention_list.map do |mention|
      Report.find(mention.mention_report_id)
    end
    @report.content = add_a_tag(@report.content)
  end

  # GET /reports/new
  def new
    @report = current_user.reports.new
  end

  def edit; end

  def create
    @report = current_user.reports.new(report_params)
    mention_id_list = @report.content.scan(%r{(?<=http://localhost:3000/reports/)\d+})
    if mention_id_list.empty?
      if @report.save
        redirect_to @report, notice: t('controllers.common.notice_create', name: Report.model_name.human)
      else
        render :new, status: :unprocessable_entity
      end
    else
      result = @report.transaction do
        @report.save!
        create_mentions(mention_id_list)
      end
      if result
        redirect_to @report, notice: t('controllers.common.notice_create', name: Report.model_name.human)
      else
        render :new, status: :unprocessable_entity
      end
    end
  end

  def update
    mentioning_list = @report.mentioning_reports
    mention_id_list = report_params[:content].scan(%r{(?<=http://localhost:3000/reports/)\d+})
    if mentioning_list.empty? && mention_id_list.empty?
      if @report.update(report_params)
        redirect_to @report, notice: t('controllers.common.notice_update', name: Report.model_name.human)
      else
        render :edit, status: :unprocessable_entity
      end
    else
      result = @report.transaction do
        @report.update(report_params)
        destroy_mentions(mentioning_list)
        create_mentions(mention_id_list)
      end
      if result
        redirect_to @report, notice: t('controllers.common.notice_create', name: Report.model_name.human)
      else
        render :edit, status: :unprocessable_entity
      end
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

  def add_a_tag(content)
    URI.extract(content, %w[http https]).uniq.each do |url|
      content.gsub!(url, "<a href='#{url}'>#{url}</a>")
      content.gsub!("\n", '<br>')
    end
    content
  end

  def create_mentions(mention_id_list)
    mention_id_list.uniq.each do |mention_id|
      Mention.create(mention_report: @report, mentioned_report: Report.find(mention_id.to_i)) unless mention_id.to_i == @report.id
    end
  end

  def destroy_mentions(mentioning_list)
    mentioning_list.each(&:destroy)
  end
end
