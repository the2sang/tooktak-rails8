class BillingsController < ApplicationController
  before_action :set_billing, only: [:show, :edit, :update, :destroy]

  def index
    @billings = Billing.includes(:project).order(billing_month: :desc)
    @billings = @billings.where(project_id: params[:project_id]) if params[:project_id].present?
  end

  def show; end

  def new
    @billing = Billing.new(project_id: params[:project_id])
  end

  def create
    @billing = Billing.new(billing_params)
    @billing.created_by = Current.user
    if @billing.save
      redirect_to @billing, notice: "기성청구가 등록되었습니다."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @billing.update(billing_params)
      redirect_to @billing, notice: "기성청구가 수정되었습니다."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @billing.destroy
    redirect_to billings_path, notice: "기성청구가 삭제되었습니다."
  end

  private

  def set_billing
    @billing = Billing.find(params[:id])
  end

  def billing_params
    params.require(:billing).permit(
      :billing_no, :project_id, :billing_month, :progress_rate,
      :claim_amount, :approved_amount, :payment_status, :submitted_at, :approved_at, :paid_at
    )
  end
end
