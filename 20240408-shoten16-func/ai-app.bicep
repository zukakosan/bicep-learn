param location string = resourceGroup().location
param suffix string = 'zukako'

var cognitiveServiceName = 'aoai${uniqueString(resourceGroup().id)}${suffix}'
var appServicePlanName = 'asp-${uniqueString(resourceGroup().id)}${suffix}'
var appServiceName = 'apps-${suffix}'

resource AOAI 'Microsoft.CognitiveServices/accounts@2023-05-01' = {
  name: cognitiveServiceName
  location: location
  sku: {
    name: 'S0'
  }
  kind: 'OpenAI'
  properties: {
    apiProperties: {
      statisticsEnabled: false
    }
  }
}

resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: appServicePlanName
  location: location
  properties: {
    reserved: true
  }
  sku: {
    name: 'F1'
  }
  kind: 'linux'
}

resource appService 'Microsoft.Web/sites@2022-09-01' = {
  name: appServiceName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      appSettings: [
        {
          name: 'AZURE_OPENAI_SERVICE_KEY'
          value: cognitiveService.listKeys().key1
        }
      ]
    }
  }
}
