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

resource fileService 'Microsoft.Storage/storageAccounts/fileServices@2023-01-01' = {
  name: 'default'
  parent: strgAcct
  properties: {
  }
}

resource share 'Microsoft.Storage/storageAccounts/fileServices/shares@2023-01-01' = {
  name: 'share1'
  parent: fileService
  properties: {
    accessTier: 'Hot'
    enabledProtocols: 'SMB'
    signedIdentifiers: [
    ]
  }
}
