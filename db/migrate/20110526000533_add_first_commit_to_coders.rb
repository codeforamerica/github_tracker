class AddFirstCommitToCoders < ActiveRecord::Migration
  def self.up
    add_column :coders, :first_commit, :datetime
  end

  def self.down
    remove_column :coders, :first_commit
  end
end