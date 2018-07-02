Deface::Override.new(
  virtual_path: 'spree/layouts/admin',
  name: 'add_customer_segmentation_tab_to_admin_side_menu',
  insert_bottom: "[data-hook='admin_tabs'], #admin_tabs[data-hook]",
  partial: 'spree/admin/shared/customer_segmentation_side_menu',
)
