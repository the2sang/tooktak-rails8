class SafetyChecksController < ApplicationController
  before_action :set_safety_check, only: [:show, :edit, :update, :destroy]

  def index
    @safety_checks = SafetyCheck.includes(:project, :checker).order(check_date: :desc)
    @safety_checks = @safety_checks.where(project_id: params[:project_id]) if params[:project_id].present?
  end

  def show
    @items = @safety_check.items.order(:id)
  end

  def new
    @safety_check = SafetyCheck.new(project_id: params[:project_id], check_date: Date.current)
  end

  def create
    @safety_check = SafetyCheck.new(safety_check_params)
    @safety_check.checker = Current.user
    if @safety_check.save
      redirect_to @safety_check, notice: "안전점검이 등록되었습니다."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @safety_check.update(safety_check_params)
      redirect_to @safety_check, notice: "안전점검이 수정되었습니다."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @safety_check.destroy
    redirect_to safety_checks_path, notice: "안전점검이 삭제되었습니다."
  end

  private

  def set_safety_check
    @safety_check = SafetyCheck.find(params[:id])
  end

  def safety_check_params
    params.require(:safety_check).permit(:project_id, :check_date, :overall_result, :notes)
  end
end
