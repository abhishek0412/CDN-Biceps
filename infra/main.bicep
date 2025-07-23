@description('Prefix for resource names')
// Use static resource names
var storageAccountName = 'crestavenuecdnstorage'
var cdnProfileName = 'crestavenuecdnprofile'
var cdnEndpointName = 'crestavenuecdnendpoint'
var containerName = 'publicfiles'

// Create a user-assigned managed identity for deployment script
resource deploymentScriptIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: 'crestavenuecdnscriptid'
  location: resourceGroup().location
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageAccountName
  location: 'eastus'
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
    allowBlobPublicAccess: true
    minimumTlsVersion: 'TLS1_2'
  }
}

resource blobContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-01-01' = {
  name: '${storageAccount.name}/default/${containerName}'
  properties: {
    publicAccess: 'Blob'
  }
}

resource cdnProfile 'Microsoft.Cdn/profiles@2023-05-01' = {
  name: cdnProfileName
  location: 'global'
  sku: {
    name: 'Standard_Microsoft'
  }
}

resource cdnEndpoint 'Microsoft.Cdn/profiles/endpoints@2023-05-01' = {
  name: cdnEndpointName
  parent: cdnProfile
  location: 'global'
  properties: {
    origins: [
      {
        name: 'storageOrigin'
        properties: {
          hostName: '${storageAccount.name}.blob.core.windows.net'
        }
      }
    ]
    isHttpAllowed: false
    isHttpsAllowed: true
    deliveryPolicy: {
      description: 'Bypass cache for all requests'
      rules: [
        {
          name: 'BypassCacheRule'
          order: 1
          conditions: []
          actions: [
            {
              name: 'CacheExpiration'
              parameters: {
                cacheBehavior: 'BypassCache'
                cacheType: 'All'
                typeName: 'DeliveryRuleCacheExpirationAction'
              }
            }
          ]
        }
      ]
    }
  }
}

output storageAccountName string = storageAccountName
output containerName string = containerName
output cdnEndpointUrl string = 'https://${cdnEndpointName}.azureedge.net/${containerName}/sample.json'

// Assign Storage Blob Data Contributor role to the managed identity
resource blobContributorRole 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(storageAccount.id, deploymentScriptIdentity.id, 'ba92f5b4-2d11-453d-a403-e96b0029c9fe')
  scope: storageAccount
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'ba92f5b4-2d11-453d-a403-e96b0029c9fe')
    principalId: deploymentScriptIdentity.properties.principalId
  }
  dependsOn: [storageAccount, deploymentScriptIdentity]
}

// Deployment script to upload sample.json
resource uploadSampleJson 'Microsoft.Resources/deploymentScripts@2020-10-01' = {
  name: 'uploadSampleJsonScript'
  location: resourceGroup().location
  kind: 'AzureCLI'
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${deploymentScriptIdentity.id}': {}
    }
  }
  properties: {
    azCliVersion: '2.53.0'
    timeout: 'PT10M'
    retentionInterval: 'P1D'
    scriptContent: '''
      echo "{ \"product\": \"Azure CDN Demo\", \"version\": \"1.0\", \"description\": \"This is a sample JSON file for public download.\", \"date\": \"2025-07-23\" }" > sample.json
      az storage blob upload --account-name $storageAccountName --container-name $containerName --name sample.json --file sample.json --auth-mode login
    '''
    environmentVariables: [
      {
        name: 'storageAccountName'
        value: storageAccountName
      }
      {
        name: 'containerName'
        value: containerName
      }
    ]
    forceUpdateTag: uniqueString(resourceGroup().id)
    cleanupPreference: 'OnSuccess'
  }
  dependsOn: [blobContainer, blobContributorRole]
}
