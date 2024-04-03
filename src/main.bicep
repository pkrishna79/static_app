param appName string ='webapptest'
param repositoryUrl string ='https://github.com/pkrishna79/static_app.git'
param repositoryBranch string = 'main'
param profileName string ='testprofile'
param endpointName string = 'Test-b7g0hubjfygnctbe.z03.azurefd.net'
param location string = 'westeurope'
param skuName string = 'Free'
param skuTier string = 'Free'
param CDNSku string = 'Standard_Microsoft'
param originUrl string

resource mystorageacc 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: 'ata2021bicepdiskstorage'
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
        
  }
}

resource profile 'Microsoft.Cdn/profiles@2021-06-01' = {
  name: profileName
  location: location
  sku: {
    name: CDNSku
  }
}

resource endpoint 'Microsoft.Cdn/profiles/endpoints@2021-06-01' = {
  parent: profile
  name: endpointName
  location: location
  properties: {
    originHostHeader: repositoryUrl
    isHttpAllowed: true
    isHttpsAllowed: true
    queryStringCachingBehavior: 'IgnoreQueryString'
    contentTypesToCompress: [
      'text/html'
      'text/javascript'
     ]
    isCompressionEnabled: true
    origins: [
      {
        name: 'origin1'
        properties: {
          hostName: originUrl
        }
      }
    ]
  }
}

resource staticWebApp 'Microsoft.Web/staticSites@2023-01-01' = {
  name: appName
  location: location
  sku: {
    name: skuName
    tier: skuTier
  }
  properties: {
    provider: 'DevOps'
    repositoryUrl: repositoryUrl
    branch: repositoryBranch
    buildProperties: {
      skipGithubActionWorkflowGeneration: true
    }
  }
}

output deployment_token string = listSecrets(staticWebApp.id, staticWebApp.apiVersion).properties.apiKey
output staticWebAppId string = staticWebApp.id
output staticWebAppName string = staticWebApp.name
