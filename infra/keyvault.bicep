@description('Prefix for resource names')
param prefix string = 'cdn'

@description('Location for Key Vault')
param location string = 'eastus'

@description('Key Vault name, generated at runtime for uniqueness')
var keyVaultName = '${prefix}${uniqueString(resourceGroup().id)}kv'

resource keyVault 'Microsoft.KeyVault/vaults@2023-02-01' = {
  name: keyVaultName
  location: location
  properties: {
    tenantId: subscription().tenantId
    sku: {
      family: 'A'
      name: 'standard'
    }
    accessPolicies: []
    enableSoftDelete: true
    enablePurgeProtection: true
    publicNetworkAccess: 'Disabled'
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
    }
  }
}

output keyVaultName string = keyVaultName
output keyVaultId string = keyVault.id
