class AddConfirmableAndLockableToUsers < ActiveRecord::Migration[5.0]
  
	def up
		## Confirmable
	  add_column :users, :confirmation_token, :string
	  add_column :users, :confirmed_at, :datetime
	  add_column :users, :confirmation_sent_at, :datetime
	  add_column :users, :unconfirmed_email, :string # Only if using reconfirmable

	  ## Lockable
	  add_column :users, :failed_attempts, :integer, default: 0, null: false
	  add_column :users, :unlock_token, :string
	  add_column :users, :locked_at, :datetime

	  add_index :users, :confirmation_token, unique: true
	 	add_index :users, :unlock_token, unique: true
  end

  def down
    remove_columns :users, :confirmation_token, :confirmed_at, :confirmation_sent_at
  end
end
