// scope を Subscription に設定
targetScope = 'subscription'

// このポリシーでは、リソースをデプロイするときに組織が指定できる場所を制限できるようになります。geo コンプライアンス要件を適用するときに使用します。リソース グループ、Microsoft.AzureActiveDirectory/b2cDirectories、'グローバル' リージョンを使用するリソースは除外されます。
@description('policy id')
param policyDefinitionID string = '/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c'
@description('policy assignment name')
param policyAssignmentName string = 'test-assignment-by-bicep'

var location = 'japaneast'

// https://learn.microsoft.com/ja-jp/azure/templates/microsoft.authorization/policyassignments?pivots=deployment-language-bicep
resource assignment 'Microsoft.Authorization/policyAssignments@2022-06-01' = {
  name: policyAssignmentName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
      policyDefinitionId: policyDefinitionID
      parameters:{
        listOfAllowedLocations: {
          value: [
            'japaneast','japanwest'
          ]
        }
      }
  }
}

output assignmentId string = assignment.id
