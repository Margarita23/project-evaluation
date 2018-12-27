class OpportunitiesController < ApplicationController
  load_and_authorize_resource :project
  load_and_authorize_resource :opportunity, throw: :project
  
  def create
    @opportunity = @project.opportunities.build(opportunity_params)
    if @opportunity.save
      flash[:notice] = "Новая возможность успешно создана"
    else
      flash[:alert] = "Новая возможность не создана." 
    end
    redirect_back(fallback_location: root_path)
  end
  
  def update
    if @opportunity.update(opportunity_params)
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
  
  private
  
  def opportunity_params
    params.require(:opportunity).permit(:name)
  end
end