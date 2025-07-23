// Deploy infra/main.bicep into the existing resource group CrestAvenue-EU
module infraModule './infra/main.bicep' = {
  name: 'infraDeployment'
  scope: resourceGroup('CrestAvenue-EU')
  params: {
    prefix: 'cdn'
  }
}
