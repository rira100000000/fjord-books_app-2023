class AddAddressZipCodeIntroductionToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :address, :string
    add_column :users, :zip_code, :string
    add_column :users, :introduction, :text
  end
end
