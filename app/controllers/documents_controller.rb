class DocumentsController < ApplicationController
  before_action :set_document, only: [:show, :edit, :update, :destroy]

  def index
    @documents = Document.includes(:project, :uploaded_by).order(created_at: :desc)
    @documents = @documents.where(project_id: params[:project_id]) if params[:project_id].present?
  end

  def show; end

  def new
    @document = Document.new(project_id: params[:project_id])
  end

  def create
    @document = Document.new(document_params)
    @document.uploaded_by = Current.user
    if @document.save
      redirect_to @document, notice: "문서가 등록되었습니다."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @document.update(document_params)
      redirect_to @document, notice: "문서가 수정되었습니다."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @document.destroy
    redirect_to documents_path, notice: "문서가 삭제되었습니다."
  end

  private

  def set_document
    @document = Document.find(params[:id])
  end

  def document_params
    params.require(:document).permit(
      :project_id, :work_order_id, :issue_id, :inspection_id,
      :doc_type, :title, :description, :file_name, :file_url, :file_size, :mime_type
    )
  end
end
