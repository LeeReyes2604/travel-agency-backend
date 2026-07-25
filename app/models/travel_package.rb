# frozen_string_literal: true

class TravelPackage < ApplicationRecord
  MAX_PHOTOS = 8

  include SoftDeletable

  has_rich_text :description

  validates :title, presence: true
  validates :description, presence: true
  validates :destination, presence: true
  validates :is_active, presence: true
  validates :number_of_travelers, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :base_price,
            presence: true,
            numericality: { greater_than: 0 }
  validate :travel_package_photos_positions
  validates :travel_package_photos, length: { maximum: MAX_PHOTOS, message: "you can only upload upto 8 photos" }
  validates :travel_package_photos, length: { minimum: 1, message: "atleast 1 photo is required" }
  scope :active, -> { where(is_active: true) }
  scope :destination, ->(destination) { where(destination: destination) if destination.present? }

  before_save :set_excerpt

  default_scope { where(deleted_at: nil) }

  has_many :inquiries, dependent: :destroy
  has_many :travel_package_photos
  has_one :cover_photo, -> { order(position: :asc) }, class_name: "TravelPackagePhoto"
  accepts_nested_attributes_for :travel_package_photos, allow_destroy: true

  def set_excerpt
    self.excerpt = description.to_plain_text.truncate(150)
  end

  def active?
    is_active
  end

  private

  def travel_package_photos_positions
    positions = self.travel_package_photos.map(&:position)

    return if positions.sort == (1..travel_package_photos.length).to_a

    errors.add(:travel_package_photos, "positions must be consecutive starting from 1")
  end
end