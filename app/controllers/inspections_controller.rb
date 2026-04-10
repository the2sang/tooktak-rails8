class InspectionsController < ApplicationController
  before_action :set_inspection, only: [:show, :edit, :update, :destroy]

  def index
    @inspections = Inspection.includes(:project, :inspector).order(created_at: :desc)
    @inspections = @inspections.where(project_id: params[:project_id]) if params[:project_id].present?
  end

  def show
    @results = @inspection.results.includes(:template_item)
  end

  def new
    @inspection = Inspection.new(project_id: params[:project_id])
  end

  def create
    @inspection = Inspection.new(inspection_params)
    @inspection.created_by = Current.user
    if @inspection.save
      redirect_to @inspection, notice: "검사가 등록되었습니다."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @inspection.update(inspection_params)
      redirect_to @inspection, notice: "검사가 수정되었습니다."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @inspection.destroy
    redirect_to inspections_path, notice: "검사가 삭제되었습니다."
  end

  private

  def set_inspection
    @inspection = Inspection.find(params[:id])
  end

  def inspection_params
    params.require(:inspection).permit(
      :project_id, :work_order_id, :template_id, :inspection_type,
      :status, :title, :location, :floor, :scheduled_date, :inspected_date,
      :inspector_id, :result_notes
    )
  end
end
