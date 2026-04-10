class WorkersController < ApplicationController
  before_action :set_worker, only: [:show, :edit, :update, :destroy]

  def index
    @workers = Worker.includes(:company).where(is_active: true).order(:name)
  end

  def show
    @attendances = @worker.attendances.includes(:project).order(work_date: :desc).limit(20)
  end

  def new
    @worker = Worker.new
  end

  def create
    @worker = Worker.new(worker_params)
    if @worker.save
      redirect_to @worker, notice: "근로자가 등록되었습니다."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @worker.update(worker_params)
      redirect_to @worker, notice: "근로자 정보가 수정되었습니다."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @worker.destroy
    redirect_to workers_path, notice: "근로자가 삭제되었습니다."
  end

  private

  def set_worker
    @worker = Worker.find(params[:id])
  end

  def worker_params
    params.require(:worker).permit(:name, :phone, :company_id, :trade, :skill_level, :license_no, :is_active)
  end
end
