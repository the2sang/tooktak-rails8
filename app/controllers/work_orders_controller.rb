class WorkOrdersController < ApplicationController
  before_action :set_work_order, only: [:show, :edit, :update, :destroy]

  def index
    @work_orders = WorkOrder.includes(:project, :assigned_to, :category).order(created_at: :desc)
    @work_orders = @work_orders.where(project_id: params[:project_id]) if params[:project_id].present?
    @work_orders = @work_orders.where(status: params[:status]) if params[:status].present?
  end

  def show
    @issues = @work_order.issues.includes(:assigned_to)
    @inspections = @work_order.inspections.includes(:inspector)
  end

  def new
    @work_order = WorkOrder.new(project_id: params[:project_id])
  end

  def create
    @work_order = WorkOrder.new(work_order_params)
    @work_order.created_by = Current.user
    if @work_order.save
      redirect_to @work_order, notice: "작업지시서가 등록되었습니다."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @work_order.update(work_order_params)
      redirect_to @work_order, notice: "작업지시서가 수정되었습니다."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @work_order.destroy
    redirect_to work_orders_path, notice: "작업지시서가 삭제되었습니다."
  end

  private

  def set_work_order
    @work_order = WorkOrder.find(params[:id])
  end

  def work_order_params
    params.require(:work_order).permit(
      :order_no, :project_id, :category_id, :title, :description,
      :location, :floor, :status, :priority,
      :planned_start, :planned_end, :actual_start, :actual_end,
      :estimated_hours, :actual_hours, :assigned_to_id, :subcontract_id, :parent_order_id
    )
  end
end
