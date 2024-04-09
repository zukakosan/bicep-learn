param location string = resourceGroup().location

var nsgName = 'nsg-${location}'
var securityRules = loadJsonContent('./nsgrules/rules.json')

resource nsg 'Microsoft.Network/networkSecurityGroups@2023-04-01' = {
  name: nsgName
  location: location
  properties: {
    securityRules: securityRules
  }
}
