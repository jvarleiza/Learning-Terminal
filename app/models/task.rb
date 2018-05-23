class Task < ApplicationRecord
    # enum task_type: [:just_once, :daily, :weekly, :bi_weekly, :monthly, :quarterly, :annually]
    enum task_type: [:daily, :weekly, :bi_weekly, :monthly, :quarterly, :bi_annually, :annually]
    
    has_and_belongs_to_many :roles
    has_and_belongs_to_many :process_lts
    
    has_and_belongs_to_many(:tasks,
    :join_table => :related_tasks,
    :foreign_key => :task_a_id,
    :association_foreign_key => :task_b_id)
end
