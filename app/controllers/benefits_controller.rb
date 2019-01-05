class BenefitsController < ApplicationController
  load_and_authorize_resource :project
  load_and_authorize_resource :benefit, throw: :project

  
rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found

  def create
    @benefit = @project.benefits.new(name: "Новая выгода")
    if @benefit.save
      flash[:notice] = "Новая выгода успешно создана"
    else
      flash[:alert] = "Новая выгода не создана. Исправьте выгоду с именем 'Новая выгода'" 
    end
    redirect_back(fallback_location: root_path)
  end

  def update
    if @benefit.update(update_params)
      flash[:notice] = "Имя выгоды успешно изменено"
    else
      flash[:alert] = "Имя выгоды должно быть уникальным"
    end
    redirect_back(fallback_location: root_path)
  end

  def destroy
    @benefit.destroy
    redirect_back(fallback_location: root_path)
    flash[:notice] = "Выгода успешно удалена"
  end

  def handle_record_not_found
    render :not_found_aspect
  end

  private

  def update_params
    params.require(:benefit).permit(:name)
  end
end