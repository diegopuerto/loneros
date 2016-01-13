class AddInfoPagoToUsuarios < ActiveRecord::Migration
  def change
	add_column :usuarios, :info_pago, :text
  end
end
