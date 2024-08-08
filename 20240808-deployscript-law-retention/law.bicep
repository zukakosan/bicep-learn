param location string = 'eastus'
param suffix string = 'zukako'
param lawRetentionInDays int = 90

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2020-10-01' = {
  name: 'law-${suffix}'
  location: location
  properties: {
    // 
    retentionInDays: lawRetentionInDays
    sku: {
      name: 'pergb2018'
    }
  }
}

var tableName = 'AzureDiagnostics'
var contributorRoleId = 'b24988ac-6180-42a0-ab88-20f7382dd24c'
var subscriptionId = 'b957570e-6156-44f9-b1e5-22d285da0dc0'
var tableRetention = 30
var tableTotalRetention = 500

resource scriptIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-07-31-preview' = {
  name: 'script-identity'
  location: location
}

resource contributorRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(scriptIdentity.id, contributorRoleId)
  properties: {
    principalType: 'ServicePrincipal'
    principalId: scriptIdentity.properties.principalId
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', contributorRoleId)
  }
}

// スクリプト内でテーブル名の一覧を取得してループ回せば対象のテーブルの合計保持期間のみ更新できる
// 今回はAzureDiagnosticsのみを対象としている（Azure Diagnosticsが存在する前提）
resource script 'Microsoft.Resources/deploymentScripts@2023-08-01' = {
  name: 'script'
  location: location
  kind: 'AzureCLI'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${scriptIdentity.id}': {}
    }
  }
  properties: {
    azCliVersion: '2.59.0'
    retentionInterval: 'PT1H'
    arguments: '${subscriptionId} ${resourceGroup().name} ${logAnalyticsWorkspace.name} ${tableName} ${tableRetention} ${tableTotalRetention}'
    scriptContent: '''
      #!/bin/bash
      set -e
      az monitor log-analytics workspace table update --subscription $1 --resource-group $2 --workspace-name $3 --name $4 --retention-time $5 --total-retention-time $6
    '''
  }
}
