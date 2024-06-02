param location string = resourceGroup().location

@secure()
param administratorLoginPassword string
param administratorLogin string = 'dba'

param dbServerName string = 'sqlServer1SyskitDomagoj'
param dbName string = 'db'
param elasticPoolName string = 'elasticPool1'

param appServicePlanName string = 'appserviceplan1'
param appName string = 'webappSyskitDomagoj'
param runtimeStack string = 'Python|3.11'

resource sqlServer 'Microsoft.Sql/servers@2023-05-01-preview' = {
  name: dbServerName
  location: location
  properties: {
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
    publicNetworkAccess: 'Enabled'
    restrictOutboundNetworkAccess: 'Disabled'
  }
}

resource sqlElasticPool 'Microsoft.Sql/servers/elasticPools@2023-05-01-preview' = {
  name: elasticPoolName
  location: location
  parent: sqlServer
  sku: {
    name: 'BasicPool'
    capacity: 50
  }
}

resource sqlDatabases 'Microsoft.Sql/servers/databases@2023-05-01-preview' = [for i in range(1,3): {
  name: '${dbName}${i}'
  parent: sqlServer
  location: location
  properties: {
    elasticPoolId: sqlElasticPool.id
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    createMode: 'Default'
    zoneRedundant: false
  }
}]

resource appServicePlan 'Microsoft.Web/serverfarms@2020-06-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: 'F1'
  }
  kind: 'linux'
}

resource webApp 'Microsoft.Web/sites@2023-12-01' =[for i in range(1,3): {
  name: '${appName}${i}'
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      pythonVersion: '3.11'
      linuxFxVersion: runtimeStack
    }
  }
}]
