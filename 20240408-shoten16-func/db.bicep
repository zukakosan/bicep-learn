param location string = resourceGroup().location
param administratorLogin string
@secure()
param administratorLoginPassword string
param suffix string

var serverName = 'sqlserver${uniqueString(resourceGroup().id)}${suffix}'
var sqlDBName = 'sqldb'

resource sqlServer 'Microsoft.Sql/servers@2023-05-01-preview' = {
  name: serverName
  location: location
  properties: {
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
  }
}

resource sqlDB 'Microsoft.Sql/servers/databases@2023-05-01-preview' = {
  parent: sqlServer
  name: sqlDBName
  location: location
  sku: {
    name: 'Standard'
    tier: 'Standard'
  }
}

output sqlServerName string = sqlDB.listKeys().connectionStrings[0].connectionString
