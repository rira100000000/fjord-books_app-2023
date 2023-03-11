# frozen_string_literal: true

class ReportsController < ApplicationController
  before_action :set_report, only: %i[edit update destroy]

  def index
    @reports = Report.includes(:user).order(id: :desc).page(params[:page])
  end

  def show
    @report = Report.find(params[:id])
    mention_list = Mention.where(mentioned_report_id: @report.id)
    @mention_reports = mention_list.map do |mention|
      Report.find(mention.mention_report_id)
    end
  end

  # GET /reports/new
  def new
    @report = current_user.reports.new
  end

  def edit; end

  def create
    @report = current_user.reports.new(report_params)
    @mention_id_list = @report.content.scan(%r{(?<=http://localhost:3000/reports/)\d+})
    if @mention_id_list.empty?
      if @report.save
        redirect_to @report, notice: t('controllers.common.notice_create', name: Report.model_name.human)
      else
        render :new, status: :unprocessable_entity
      end
    else
      result = @report.transaction do
        @report.save!
        create_mentions(@mention_id_list)
      end
      if result
        redirect_to @report, notice: t('controllers.common.notice_create', name: Report.model_name.human)
      else
        render :new, status: :unprocessable_entity
      end
    end
  end

  def update
    if @report.update(report_params)
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
      Mention.create(mention_report: @report, mentioned_report: Report.find(mention_id.to_i))
    end
  end
end
