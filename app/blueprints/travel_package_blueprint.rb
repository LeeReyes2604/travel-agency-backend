# frozen_string_literal: true

class TravelPackageBlueprint < Blueprinter::Base
  identifier :id

  fields :title,
         :base_price,
         :show_price,
         :number_of_travelers,
         :destination,
         :is_active,
         :excerpt

  field :created_at do |obj|
    obj.created_at.iso8601
  end

  field :updated_at do |obj|
    obj.updated_at.iso8601
  end

  view :preview do
    field :cover_photo do |travel_package|
      TravelPackagePhotoBlueprint.render_as_hash(travel_package.cover_photo)
    end
  end

  view :detailed do
    field :description do |travel_package|
      travel_package.description.to_s
    end

    association :travel_package_photos,
                blueprint: TravelPackagePhotoBlueprint
  end
end