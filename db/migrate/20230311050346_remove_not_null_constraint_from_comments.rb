class RemoveNotNullConstraintFromComments < ActiveRecord::Migration[7.0]
  change_column_null :comments, :user_id, true
end
