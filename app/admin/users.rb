ActiveAdmin.register Server do
  config.filters = false

  sidebar :threads_management do
    button_to 'After Add', '/admin/servers/addservers', method: :post, confirm: 'Are you sure?', style: 'margin-left: 70px'
  end

  sidebar :threads_management do
    button_to 'After Update', '/admin/servers/updatemodels', method: :post, confirm: 'Are you sure?', style: 'margin-left: 63px'
  end

  sidebar :threads_management do
    button_to 'After Delete', '/admin/servers/deleteservers', method: :post, confirm: 'Are you sure?', style: 'margin-left: 63px'
  end

  collection_action :updatemodels, method: :post do
    $threads.update_models
    redirect_to admin_servers_path, notice: 'Updated'
  end

  collection_action :deleteservers, method: :post do
    $threads.delete_threads
    redirect_to admin_servers_path, notice: 'Deleted'
  end

  collection_action :addservers, method: :post do
    $threads.add_threads
    redirect_to admin_servers_path, notice: 'Added'
  end
end
