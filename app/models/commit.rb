class Commit 
  include Mongoid::Document
  belongs_to :project
  belongs_to :coder
  belongs_to :org  
  
  field :project_id
  field :coder_id
  field :org_id
  field :sha
  field :branch
  field :message
  field :committed_date, type: DateTime
  
  index :sha
  index :project_id
  index :coder_id
  index :org_id
  index :committed_date
  
  validates_uniqueness_of :sha
  
  def find_or_create(options={})
    commit = Commit.where(:sha => options[:sha]).first
    !commit.blank? ? commit : Commit.create!(options)
  end

  # return commits in array by day and coder
  # {"05/01/2011" => {:sferik => [50], :ryan => [23]},
  # "05/02/2011" => {:sferik => [50], :ryan => [23]}, ]
  def by_day
    map = "function() {
      day = new Date(this.committed_date.getFullYear(), this.committed_date.getMonth(), this.committed_date.getDate());
      emit({day: day, coder_id: this.coder_id}, {count: 1});
    }"

    reduce = "function(key, values) {
      var count = 0;
      values.forEach(function(v) {
        count += v['count'];
      });
      return {count: count};
    }"

    s = Commit.collection.map_reduce(map, reduce)
    commits = Commit.order_by([:committed_date, :asc])
    dates = commits.map { |x| x.committed_date.strftime('%Y/%m/%d') }.uniq!
    commits.group_by
  end
  

    
end