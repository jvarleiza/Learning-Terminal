class Role < ApplicationRecord
    has_and_belongs_to_many :process_lts
    has_and_belongs_to_many :tasks
    
    has_and_belongs_to_many(:roles,
    :join_table => :related_roles,
    :foreign_key => :role_a_id,
    :association_foreign_key => :role_b_id)
end
