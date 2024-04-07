param location string = 'japaneast'
param suffix string = 'zukako'

var strgName = 'strg${suffix}'

resource strgAcct 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: strgName
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Premium_LRS'
  }
}

output strgAcctId string = strgAcct.id
