param location string = resourceGroup().location
param suffix string = 'zukako'

var strgName = 'strg${uniqueString(resourceGroup().id)}${suffix}'

resource strgAcct 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: strgName
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}
