class CreateDays < ActiveRecord::Migration
  def change
    create_table :days do |t|
      t.string :date
      t.integer :score0
      t.integer :score1

      t.timestamps
    end
  end
end
