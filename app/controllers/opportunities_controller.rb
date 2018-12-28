class OpportunitiesController < ApplicationController
  load_and_authorize_resource :project
  load_and_authorize_resource :opportunity, throw: :project

  
rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found

  def create
    @opportunity = @project.opportunities.build(create_params)
    if @opportunity.save
      flash[:notice] = "Новая возможность успешно создана"
    else
      flash[:alert] = "Новая возможность не создана." 
    end
    redirect_back(fallback_location: root_path)
  end

  def update
    if @opportunity.update(update_params)
      flash[:notice] = "Имя возможности успешно изменено"
    else
      flash[:aleert] = "Имя возможности не изменено"
    end
    redirect_back(fallback_location: root_path)
  end

  def destroy
    @opportunity.destroy
    redirect_back(fallback_location: root_path)
    flash[:notice] = "Возможность успешно удалена"
  end

  def handle_record_not_found
    render :not_found_aspect
  end

  private
  
  def create_params
    params.permit(:name)
  end

  def update_params
    params.require(:opportunity).permit(:name)
  end
end