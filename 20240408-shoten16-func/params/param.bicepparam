using '../vm.bicep'

param suffix = 'zukako'
param adminUserName = 'AzureAdmin'
param adminPassword = readEnvironmentVariable('ADMIN_PASSWORD')
