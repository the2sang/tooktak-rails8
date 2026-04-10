class DailyReportsController < ApplicationController
  before_action :set_daily_report, only: [:show, :edit, :update, :destroy]

  def index
    @daily_reports = DailyReport.includes(:project, :created_by).order(report_date: :desc)
    @daily_reports = @daily_reports.where(project_id: params[:project_id]) if params[:project_id].present?
  end

  def show
    @items = @daily_report.items.includes(:work_order, :category)
  end

  def new
    @daily_report = DailyReport.new(project_id: params[:project_id], report_date: Date.current)
  end

  def create
    @daily_report = DailyReport.new(daily_report_params)
    @daily_report.created_by = Current.user
    if @daily_report.save
      redirect_to @daily_report, notice: "작업일보가 등록되었습니다."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @daily_report.update(daily_report_params)
      redirect_to @daily_report, notice: "작업일보가 수정되었습니다."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @daily_report.destroy
    redirect_to daily_reports_path, notice: "작업일보가 삭제되었습니다."
  end

  private

  def set_daily_report
    @daily_report = DailyReport.find(params[:id])
  end

  def daily_report_params
    params.require(:daily_report).permit(
      :project_id, :report_date, :weather, :temperature,
      :work_summary, :progress_notes, :safety_notes, :special_notes, :worker_count
    )
  end
end
