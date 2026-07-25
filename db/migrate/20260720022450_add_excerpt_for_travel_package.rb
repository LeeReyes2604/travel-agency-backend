class AddExcerptForTravelPackage < ActiveRecord::Migration[7.2]
  def change
    add_column :travel_packages, :excerpt, :text
  end
end
