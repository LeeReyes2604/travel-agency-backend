# frozen_string_literal: true

class Api::V1::Client::TravelPackagesController < Api::V1::ClientController
  def index
    travel_packages = TravelPackage.active.order(created_at: :desc)
    
    render json: {
      travel_packages: TravelPackageBlueprint.render_as_hash(travel_packages, view: :preview)
    }
  end

  def show
    travel_package = TravelPackage.find(params[:id])

    render json: TravelPackageBlueprint.render_as_hash(travel_package, view: :detailed)
  end

  def inquire
    travel_package = TravelPackage.find(params[:id])
    inquiry = travel_package.inquiries.new(inquiry_params)

    if inquiry.save
      render json: InquiryBlueprint.render_as_hash(inquiry), status: :created
    else
      render json: { error: inquiry.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end

  def inquiry_params
    params.require(:inquiry).permit(
      :email,
      :full_name,
      :phone_number,
      :number_of_travelers,
      :notes
    )
  end
end