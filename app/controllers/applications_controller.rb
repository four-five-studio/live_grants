class ApplicationsController < ApplicationController
  def show
    @application = Application.first
  end

  def edit
    @application = Application.first
  end

  def update
    @application = Application.first
    @application.update(application_params)
    respond_to do |format|
      format.html { redirect_to application_path(@application) }
      format.turbo_stream { render turbo_stream: turbo_stream.replace("average_amount", partial: "average_amount") }
    end
  end

  private

  def application_params
    params.require(:application).permit(:name, :amount, :sport, :people_count, :inactivity)
  end
end
