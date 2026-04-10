class IssuesController < ApplicationController
  before_action :set_issue, only: [:show, :edit, :update, :destroy]

  def index
    @issues = Issue.includes(:project, :assigned_to, :category).order(created_at: :desc)
    @issues = @issues.where(project_id: params[:project_id]) if params[:project_id].present?
    @issues = @issues.where(status: params[:status]) if params[:status].present?
  end

  def show
    @comments = @issue.comments.includes(:author).order(:created_at)
  end

  def new
    @issue = Issue.new(project_id: params[:project_id], work_order_id: params[:work_order_id])
  end

  def create
    @issue = Issue.new(issue_params)
    @issue.reported_by = Current.user
    if @issue.save
      redirect_to @issue, notice: "이슈가 등록되었습니다."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @issue.update(issue_params)
      redirect_to @issue, notice: "이슈가 수정되었습니다."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @issue.destroy
    redirect_to issues_path, notice: "이슈가 삭제되었습니다."
  end

  private

  def set_issue
    @issue = Issue.find(params[:id])
  end

  def issue_params
    params.require(:issue).permit(
      :issue_no, :project_id, :work_order_id, :category_id,
      :title, :description, :location, :floor,
      :status, :severity, :assigned_to_id, :due_date, :resolution
    )
  end
end
