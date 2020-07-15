class AddViewerToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :viewer, :boolean, default: true
  end
end
