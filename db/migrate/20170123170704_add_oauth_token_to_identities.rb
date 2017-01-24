class AddOauthTokenToIdentities < ActiveRecord::Migration[5.0]
  def change
    add_column :identities, :oauth_token, :string
  end
end
