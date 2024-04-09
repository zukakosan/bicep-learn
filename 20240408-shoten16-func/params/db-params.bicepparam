using '../db.bicep'

param administratorLogin = 'sqladmin'
param administratorLoginPassword = readEnvironmentVariable('SQLADMIN_PASSWORD')
param suffix = 'zukako'
