class CostsController < ApplicationController
  before_action :set_cost, only: [:show, :edit, :update, :destroy]

  def index
    @costs = Cost.includes(:project, :recorded_by).order(cost_date: :desc)
    @costs = @costs.where(project_id: params[:project_id]) if params[:project_id].present?
  end

  def show; end

  def new
    @cost = Cost.new(project_id: params[:project_id])
  end

  def create
    @cost = Cost.new(cost_params)
    @cost.recorded_by = Current.user
    if @cost.save
      redirect_to @cost, notice: "비용이 등록되었습니다."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @cost.update(cost_params)
      redirect_to @cost, notice: "비용이 수정되었습니다."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @cost.destroy
    redirect_to costs_path, notice: "비용이 삭제되었습니다."
  end

  private

  def set_cost
    @cost = Cost.find(params[:id])
  end

  def cost_params
    params.require(:cost).permit(
      :project_id, :category, :work_order_id, :subcontract_id,
      :description, :amount, :cost_date, :invoice_no, :payment_status, :paid_at
    )
  end
end
