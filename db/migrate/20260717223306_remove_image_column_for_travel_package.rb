class RemoveImageColumnForTravelPackage < ActiveRecord::Migration[7.2]
  def change
    remove_column :travel_packages, :image, :string
  end
end
