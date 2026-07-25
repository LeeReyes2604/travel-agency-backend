
# frozen_string_literal: true

class Api::V1::Admin::TravelPackagesController < Api::V1::AdminController
  before_action :set_travel_package, only: [:show, :update, :destroy]

  PER_PAGE = 10

  def index
    travel_packages = TravelPackage.includes(:cover_photo).page(params[:page]).per(PER_PAGE)
    render json: {
      travel_packages: TravelPackageBlueprint.render_as_hash(travel_packages, view: :preview),
      meta: {
        current_page: travel_packages.current_page,
        next_page: travel_packages.next_page,
        prev_page: travel_packages.prev_page,
        total_pages: travel_packages.total_pages,
        total_count: travel_packages.total_count
      }
    }
  end

  def show
    render json: TravelPackageBlueprint.render_as_hash(@travel_package, view: :detailed)
  end

  def create
    travel_package = TravelPackage.new(travel_package_params)

    if travel_package.save
      render json: TravelPackageBlueprint.render_as_hash(travel_package), status: :created
    else
      render json: { error: travel_package.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end

  def update
    if @travel_package.update(travel_package_params)
      render json: TravelPackageBlueprint.render_as_hash(@travel_package)
    else
      render json: { error: @travel_package.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end

  def destroy
    if @travel_package.destroy
      render json: { message: "Travel package deleted" }
    else
      render json: { error: @travel_package.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end

  private

  def set_travel_package
    @travel_package = TravelPackage.find(params[:id])
  end

  def travel_package_params
    params.require(:travel_package).permit(
      :title,
      :description,
      :base_price,
      :show_price,
      :number_of_travelers,
      :destination,
      :is_active,
      travel_package_photos_attributes: %i[id image alt_text position _destroy]
    )
  end
end
