# frozen_string_literal: true

class TravelPackagePhoto < ApplicationRecord
    validates :image, presence: true

    belongs_to :travel_package

    mount_uploader :image, ImageUploader
    validates :position, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
