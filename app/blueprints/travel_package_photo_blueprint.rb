# frozen_string_literal: true

class TravelPackagePhotoBlueprint < Blueprinter::Base
  identifier :id

  fields :position, :image, :travel_package_id, :created_at, :updated_at, :alt_text

  field :image_url do |obj|
    obj.image&.url
  end
end