class AddTimeToShow < ActiveRecord::Migration[6.0]
  def change
    add_column :shows, :time, :datetime
  end
end
