class RemoveDescriptionFromTravelPackages < ActiveRecord::Migration[7.2]
  def change
    remove_column :travel_packages, :description, :text
  end
end
