class MaterialsController < ApplicationController
  before_action :set_material, only: [:show, :edit, :update, :destroy]

  def index
    @materials = Material.includes(:supplier).order(:name)
    @materials = @materials.where(category: params[:category]) if params[:category].present?
  end

  def show
    @orders = @material.material_orders.includes(:project).order(created_at: :desc)
  end

  def new
    @material = Material.new
  end

  def create
    @material = Material.new(material_params)
    if @material.save
      redirect_to @material, notice: "자재가 등록되었습니다."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @material.update(material_params)
      redirect_to @material, notice: "자재 정보가 수정되었습니다."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @material.destroy
    redirect_to materials_path, notice: "자재가 삭제되었습니다."
  end

  private

  def set_material
    @material = Material.find(params[:id])
  end

  def material_params
    params.require(:material).permit(:code, :name, :category, :specification, :unit, :unit_price, :supplier_id, :is_active)
  end
end
