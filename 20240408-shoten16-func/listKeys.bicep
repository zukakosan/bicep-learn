param location string = resourceGroup().location
// param scriptResourceGroup string = 'script-share-rg'
// param scriptStrgName string = 'scriptstrgzukako'
// param scriptURI string = 'https://scriptstrgzukako.blob.core.windows.net/scripts/helloWorld.sh'

// resource scriptStrgAcct 'Microsoft.Storage/storageAccounts@2023-01-01' existing = {
//   scope: resourceGroup(scriptResourceGroup)
//   name: scriptStrgName
// }

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

resource deploymentScript 'Microsoft.Resources/deploymentScripts@2023-08-01' = {
  name: 'executeScript'
  location: location
  kind: 'AzureCLI'
  properties: {
    azCliVersion: '2.28.0'
    arguments: suffix
    storageAccountSettings: {
      storageAccountName: strgName
      storageAccountKey: strgAcct.listKeys().keys[0].value
    }
    forceUpdateTag: 'false'
    scriptContent: 'echo "Hello, World! for ${suffix} > $AZ_SCRIPTS_OUTPUT_PATH/output.txt"'
    retentionInterval: 'P1D'
    timeout: 'PT1H'
  }
}


// resource deploymentScript 'Microsoft.Resources/deploymentScripts@2023-08-01' = {
//   name: 'executeScript'
//   location: location
//   kind: 'AzureCLI'
//   properties: {
//     azCliVersion: '2.28.0'
//     storageAccountSettings: {
//       storageAccountName: scriptStrgName
//       storageAccountKey: scriptStrgAcct.listKeys().keys[0].value
//     }
//     forceUpdateTag: 'false'
//     primaryScriptUri: scriptURI
//     retentionInterval: 'P1D'
//     timeout: 'PT1H'
//   }
// }
