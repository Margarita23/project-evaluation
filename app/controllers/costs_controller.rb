class CostsController < ApplicationController
  load_and_authorize_resource :project
  load_and_authorize_resource :cost, throw: :project

  rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found

  def create
    @cost = @project.costs.new(name: "Новые издержки")
    if @cost.save
      flash[:notice] = "Новые издержки успешно созданы"
    else
      flash[:alert] = "Новые издержки не созданы. Исправьте издержки с именем 'Новые издержки'"
    end
    redirect_back(fallback_location: root_path)
  end

  def update
    if @cost.update(update_params)
      flash[:notice] = "Имя издержек успешно изменено"
    else
      flash[:alert] = "Имя издержек должно быть уникальным"
    end
    redirect_back(fallback_location: root_path)
  end

  def destroy
    @cost.destroy
    redirect_back(fallback_location: root_path)
    flash[:notice] = "Издержки успешно удалены"
  end

  def handle_record_not_found
    render :not_found_aspect
  end

  private

  def update_params
    params.require(:cost).permit(:name)
  end
end