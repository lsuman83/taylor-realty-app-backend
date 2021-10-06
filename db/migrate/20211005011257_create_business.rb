class CreateBusiness < ActiveRecord::Migration[6.1]
  def change
    create_table :businesses do |t|
      t.integer :rating
      t.string :phone
      t.string :business_id
      t.string :name
      t.string :image_url
      t.string :location
      t.float :distance

      t.timestamps
    end
  end
end
