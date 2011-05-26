class CreateCounters < ActiveRecord::Migration
  def self.up
    create_table :counters do |t|
      t.integer :project_id
      t.timestamps
    end
    add_index :counters, :project_id  
    
  end

  def self.down
    drop_table :counters
  end
end
