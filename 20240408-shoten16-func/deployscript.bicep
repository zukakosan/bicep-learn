param location string = 'japaneast'

resource createUserScript 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'createUserScript'
  location: location
  kind: 'AzurePowerShell'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '/subscriptions/42edd95d-ae8d-41c1-ac55-40bf336687b4/resourceGroups/nonproject/providers/Microsoft.ManagedIdentity/userAssignedIdentities/bicep-script': {}
    }
  }
  properties: {
    azPowerShellVersion: '8.3'
    scriptContent: loadTextContent('./scripts/createUser.ps1')
    retentionInterval: 'P1D'
  }
}
