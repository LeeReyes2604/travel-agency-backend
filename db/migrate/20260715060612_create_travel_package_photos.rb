class CreateTravelPackagePhotos < ActiveRecord::Migration[7.2]
  def change
    create_table :travel_package_photos do |t|
      t.timestamps
      t.string :image, null: false
      t.string :alt_text
      t.integer :position
      t.references :travel_package, null: false, foreign_key: true
    end
  end
end
