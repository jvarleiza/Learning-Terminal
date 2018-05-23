class ProcessLt < ApplicationRecord
    has_and_belongs_to_many :roles
    has_and_belongs_to_many :tasks
    
    has_and_belongs_to_many(:process_lts,
    :join_table => "related_processes",
    :foreign_key => "process_lt_a_id",
    :association_foreign_key => "process_lt_b_id")
end
