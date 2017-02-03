class AddCachedVotesToPhotos < ActiveRecord::Migration[5.0]
  def self.up
    add_column :photos, :cached_votes_total, :integer, :default => 0
    add_column :photos, :cached_votes_score, :integer, :default => 0
    add_column :photos, :cached_votes_up, :integer, :default => 0
    add_column :photos, :cached_votes_down, :integer, :default => 0
    add_column :photos, :cached_weighted_score, :integer, :default => 0
    add_column :photos, :cached_weighted_total, :integer, :default => 0
    add_column :photos, :cached_weighted_average, :float, :default => 0.0
    add_index  :photos, :cached_votes_total
    add_index  :photos, :cached_votes_score
    add_index  :photos, :cached_votes_up
    add_index  :photos, :cached_votes_down
    add_index  :photos, :cached_weighted_score
    add_index  :photos, :cached_weighted_total
    add_index  :photos, :cached_weighted_average
  end

  def self.down
    remove_column :photos, :cached_votes_total
    remove_column :photos, :cached_votes_score
    remove_column :photos, :cached_votes_up
    remove_column :photos, :cached_votes_down
    remove_column :photos, :cached_weighted_score
    remove_column :photos, :cached_weighted_total
    remove_column :photos, :cached_weighted_average
  end
end
