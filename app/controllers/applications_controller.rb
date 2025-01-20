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
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace("score", partial: "score"),
          turbo_stream.replace("average_amount", partial: "average_amount"),
          turbo_stream.replace("per_person", partial: "per_person")
        ]
      end
    end
  end

  private

  def application_params
    params.require(:application).permit(:name, :amount, :sport, :people_count, :inactivity)
  end
end
