class AddTokenToCommunicationPreferences < ActiveRecord::Migration[5.2]
  def change
    add_column :communication_preferences, :token, :string, null: true
    add_index :communication_preferences, :token

    # Run this after deployment
    #CommunicationPreferences.find_each do |cp|
    #  cp.update(token: SecureRandom.uuid)
    #end
  end
end
