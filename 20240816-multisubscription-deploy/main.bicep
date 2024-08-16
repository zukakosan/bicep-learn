targetScope = 'managementGroup'
param subscripsionIDs array

param location string = 'japaneast'
var rgname = '20240816-log'

module rg './modules/rg.bicep' = [
  for sid in subscripsionIDs: {
    name: 'rg001'
    scope: subscription(sid)
    params: {
      location: location
      resourceGroupName: rgname
    }
  }
]

module law './modules/law.bicep' = [
  for sid in subscripsionIDs: {
    scope: resourceGroup(sid, rgname)
    name: 'law001'
    params: {
      location: location
      suffix: 'test'
      lawRetentionInDays: 30
    }
    dependsOn: [
      rg
    ]
  }
]
