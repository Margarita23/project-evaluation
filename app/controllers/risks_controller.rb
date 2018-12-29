class RisksController < ApplicationController
  load_and_authorize_resource :project
  load_and_authorize_resource :risk, throw: :project

  rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found

  def create
    @risk = @project.risks.new(name: "Новый риск")
    if @risk.save
      flash[:notice] = "Новый риск успешно создан"
    else
      flash[:alert] = "Новый риск не создан. Исправьте риск с именем 'Новый риск'"
    end
    redirect_back(fallback_location: root_path)
  end

  def update
    if @risk.update(update_params)
      flash[:notice] = "Имя риска успешно изменено"
    else
      flash[:alert] = "Имя риска должно быть уникальным"
    end
    redirect_back(fallback_location: root_path)
  end

  def destroy
    @risk.destroy
    redirect_back(fallback_location: root_path)
    flash[:notice] = "Риск успешно удален"
  end

  def handle_record_not_found
    render :not_found_aspect
  end

  private

  def update_params
    params.require(:risk).permit(:name)
  end
end