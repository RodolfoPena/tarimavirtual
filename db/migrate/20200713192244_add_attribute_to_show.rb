class AddAttributeToShow < ActiveRecord::Migration[6.0]
  def change
    add_column :shows, :meeting_id, :string
  end
end
