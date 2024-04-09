param location string = resourceGroup().location
param suffix string
param subnetCount int = 5
param vnetAddressSpace string = '10.0.0.0/16'
param subnetMaskSize int = 24
param adminUserName string
@secure()
param adminPassword string

var nsgName = 'nsg-${suffix}'
var securityRules = loadJsonContent('./nsgrules/rules.json')
var vnetName = 'vnet-${suffix}'
var publicIpName = 'pip-${suffix}'
var vmName = 'vm-${suffix}'

resource nsg 'Microsoft.Network/networkSecurityGroups@2023-04-01' = {
  name: nsgName
  location: location
  properties: {
    securityRules: securityRules
  }
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2023-04-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressSpace
      ]
    }
    subnets: [
      for i in range(0, subnetCount): {
        name: 'subnet-${i}'
        properties: {
          addressPrefix: cidrSubnet(vnetAddressSpace, subnetMaskSize, i)
          networkSecurityGroup: {
            id: nsg.id
          }
        }
      }
    ]
  }
  // 本当はこう書きたいわけじゃないですが、都合上...。
  resource subnet1 'subnets' existing = {
    name: 'subnet-1'
  }
}

resource publicIp 'Microsoft.Network/publicIPAddresses@2023-04-01' = {
  name: publicIpName
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource nic 'Microsoft.Network/networkInterfaces@2023-04-01' = {
  name: '${vmName}-nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIp.id
          }
          subnet: {
            id: virtualNetwork::subnet1.id
          }
        }
      }
    ]
  }
}

resource windowsVM 'Microsoft.Compute/virtualMachines@2023-09-01' = {
  name: vmName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_D2_v4'
    }
    osProfile: {
      computerName: vmName
      adminUsername: adminUserName
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2022-datacenter-g2'
        version: 'latest'
      }
      osDisk: {
        name: '${vmName}-osdisk'
        caching: 'ReadWrite'
        createOption: 'FromImage'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
  }
}
