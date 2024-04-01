targetScope = 'tenant'

@description('The name of the main group')
param mainManagementGroupName string = 'mg-bicep'

@description('The display name for the main group')
param mainMangementGroupDisplayName string = 'Bicep Management Group'
// param managementGroups array = [
//   {
//     name: 'mg-project1-non-prod'
//     displayName: 'Project1 Non-Prod Management Group'
//     subscriptions: [
//       {
//         name: 'project1-dev'
//         workload: 'Production'
//       }
//       {
//         name: 'project1-test'
//         workload: 'Production'
//       }
//     ]
//   }
//   {
//     name: 'mg-project1-prod'
//     displayName: 'Project1 Prod Management Group'
//     subscriptions: [
//       {
//         name: 'project1-prod'
//         workload: 'Production'
//       }
//     ]
//   }  
//   {
//     name: 'mg-infrastructure'
//     displayName: 'Infrastructure Management Group'  
//     subscriptions: [    
//       {
//         name: 'infrastructure'
//         workload: 'Production'
//       }
//     ]
//   }
// ]
 
resource mainManagementGroup 'Microsoft.Management/managementGroups@2020-02-01' = {
  name: mainManagementGroupName
  scope: tenant()
  properties: {
    displayName: mainMangementGroupDisplayName
  }
}
 
