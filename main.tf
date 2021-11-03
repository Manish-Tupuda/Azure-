data "azurerm_resource_group" "rg" {
  name = "Woordurff_Sawyer"
  
}

 resource "azurerm_storage_account" "storageaccount" {
  name                     = "zwerty"
  resource_group_name      = "Woordurff_Sawyer"
  location                 = "East US"
  account_tier             = "Standard"
  account_replication_type = "LRS"

 
}
resource "azurerm_storage_container" "storagecontainer" {
  name                  = "contts"
  storage_account_name  = azurerm_storage_account.storageaccount.name
  container_access_type = "private"
}

data "archive_file" "rg" {
  type        = "zip"
  source_dir = "C:/Users/Quadrant/Desktop/sample9/build/bin/Debug/netcoreapp3.1/publish"
  output_path = "C:/Users/Quadrant/Desktop/sample9/build/bin/Debug/netcoreapp3.1/publish/func.zip"
  
}

resource "azurerm_storage_blob" "appcode" {
  name = "qwe.zip"
  storage_account_name = azurerm_storage_account.storageaccount.name
  storage_container_name = azurerm_storage_container.storagecontainer.name
  type = "Block"
  source = "C:/Users/Quadrant/Desktop/sample9/build/bin/Debug/netcoreapp3.1/publish/func.zip"
 
}


data "azurerm_storage_account_blob_container_sas" "storage_account_blob_container_sas" {
  connection_string = azurerm_storage_account.storageaccount.primary_connection_string
  container_name    = azurerm_storage_container.storagecontainer.name

  start = "2021-01-01T00:00:00Z"
  expiry = "2022-01-01T00:00:00Z"

  permissions {
    read   = true
    add    = false
    create = false
    write  = false
    delete = false
    list   = false
  }
}
resource "azurerm_app_service_plan" "rg" {
  name                = "function-consumptionas-asp"
  location            = "East US"
  resource_group_name = "Woordurff_Sawyer"
  kind                = "FunctionApp"
  reserved = true
  sku {
     tier = "Dynamic"
     size = "Y1"
   }
}

resource "azurerm_function_app" "rg" {
  name                = "newaddapp"
  resource_group_name = "Woordurff_Sawyer"
   location            = "East US"
  app_service_plan_id = azurerm_app_service_plan.rg.id
  app_settings = {
     "WEBSITE_RUN_FROM_PACKAGE"    = "https://${azurerm_storage_account.storageaccount.name}.blob.core.windows.net/${azurerm_storage_container.storagecontainer.name}/${azurerm_storage_blob.appcode.name}${data.azurerm_storage_account_blob_container_sas.storage_account_blob_container_sas.sas}",
  "FUNCTIONS_WORKER_RUNTIME" = "dotnet",
   "AzureWebJobsDisableHomepage" = "true",
  }

  os_type                    = "linux"

  site_config {
    use_32_bit_worker_process = false
  }
  storage_account_name       = azurerm_storage_account.storageaccount.name
  storage_account_access_key = azurerm_storage_account.storageaccount.primary_access_key
  version                    = "~3"

}