class AddAppledoreFlagToBirds < ActiveRecord::Migration[6.0]
  def change
    add_column :birds, :appledore, :boolean, :default => FALSE
  end
end
