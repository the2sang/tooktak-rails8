class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  def index
    @projects = Project.includes(:contractor, :manager).order(created_at: :desc)
    @projects = @projects.where(status: params[:status]) if params[:status].present?
  end

  def show
    @work_orders = @project.work_orders.includes(:assigned_to, :category).order(created_at: :desc).limit(10)
    @issues = @project.issues.includes(:assigned_to).order(created_at: :desc).limit(5)
    @members = @project.project_members.includes(:user).where(is_active: true)
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    @project.created_by = Current.user
    if @project.save
      redirect_to @project, notice: "프로젝트가 등록되었습니다."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @project.update(project_params)
      redirect_to @project, notice: "프로젝트가 수정되었습니다."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @project.destroy
    redirect_to projects_path, notice: "프로젝트가 삭제되었습니다."
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(
      :project_no, :name, :client_company_id, :contractor_id, :project_type, :status,
      :address, :latitude, :longitude, :site_area, :building_area, :total_floor_area,
      :floors_above, :floors_below, :contract_date, :start_date, :planned_end_date,
      :actual_end_date, :contract_amount, :budget_amount, :progress_rate, :manager_id,
      :description, :thumbnail_url
    )
  end
end
