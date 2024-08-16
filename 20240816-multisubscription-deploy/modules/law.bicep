param location string
param suffix string
param lawRetentionInDays int

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2020-10-01' = {
  name: 'law-${suffix}'
  location: location
  properties: {
    retentionInDays: lawRetentionInDays
    sku: {
      name: 'pergb2018'
    }
  }
}
