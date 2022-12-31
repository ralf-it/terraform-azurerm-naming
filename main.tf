terraform {
  required_version = ">=1.6.5, < 2.0.0"
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = ">= 3.3.2"
    }
  }
}

resource "random_string" "main" {
  length  = 60
  special = false
  upper   = false
  numeric = var.unique-include-numbers
}

resource "random_string" "first_letter" {
  length  = 1
  special = false
  upper   = false
  numeric = false
}



locals {
  // adding a first letter to guarantee that you always start with a letter
  random_safe_generation = join("", [random_string.first_letter.result, random_string.main.result])
  random                 = substr(coalesce(var.unique-seed, local.random_safe_generation), 0, var.unique-length)
  prefix                 = join("-", var.prefix)
  prefix_safe            = lower(join("", var.prefix))
  suffix                 = join("-", var.suffix)
  suffix_unique          = join("-", concat(var.suffix, [local.random]))
  suffix_safe            = lower(join("", var.suffix))
  suffix_unique_safe     = lower(join("", concat(var.suffix, [local.random])))
  // Names based in the recomendations of
  // https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/naming-and-tagging
  az = {
    analysis_services_server = var.enabled_all || lookup(var.enabled, "analysis_services_server", false) ? {
      name        = substr(join("", compact([local.prefix_safe, "as", local.suffix_safe])), 0, 63)
      name_unique = substr(join("", compact([local.prefix_safe, "as", local.suffix_unique_safe])), 0, 63)
      dashes      = false
      slug        = "as"
      min_length  = 3
      max_length  = 63
      scope       = "resourceGroup"
      regex       = "^[a-z][a-z0-9]+$"
      description = "Analysis Services Server"
    } : null
    api_management = var.enabled_all || lookup(var.enabled, "api_management", false) ? {
      name        = substr(join("", compact([local.prefix_safe, "apim", local.suffix_safe])), 0, 50)
      name_unique = substr(join("", compact([local.prefix_safe, "apim", local.suffix_unique_safe])), 0, 50)
      dashes      = false
      slug        = "apim"
      min_length  = 1
      max_length  = 50
      scope       = "global"
      regex       = "^[a-z][a-zA-Z0-9]+$"
      description = "Api Management"
    } : null
    app_configuration = var.enabled_all || lookup(var.enabled, "app_configuration", false) ? {
      name        = substr(join("-", compact([local.prefix, "appcg", local.suffix])), 0, 50)
      name_unique = substr(join("-", compact([local.prefix, "appcg", local.suffix_unique])), 0, 50)
      dashes      = true
      slug        = "appcg"
      min_length  = 5
      max_length  = 50
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9_-]+$"
      description = "App Configuration"
    } : null
    app_service = var.enabled_all || lookup(var.enabled, "app_service", false) ? {
      name        = substr(join("-", compact([local.prefix, "app", local.suffix])), 0, 60)
      name_unique = substr(join("-", compact([local.prefix, "app", local.suffix_unique])), 0, 60)
      dashes      = true
      slug        = "app"
      min_length  = 2
      max_length  = 60
      scope       = "global"
      regex       = "^[a-z0-9][a-zA-Z0-9-]+[a-z0-9]"
      description = "App Service"
    } : null
    app_service_environment = var.enabled_all || lookup(var.enabled, "app_service_environment", false) ? {
      name        = substr(join("-", compact([local.prefix, "ase", local.suffix])), 0, 40)
      name_unique = substr(join("-", compact([local.prefix, "ase", local.suffix_unique])), 0, 40)
      dashes      = true
      slug        = "ase"
      min_length  = 1
      max_length  = 40
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9-]+$"
      description = "App Service Environment"
    } : null
    app_service_plan = var.enabled_all || lookup(var.enabled, "app_service_plan", false) ? {
      name        = substr(join("-", compact([local.prefix, "plan", local.suffix])), 0, 40)
      name_unique = substr(join("-", compact([local.prefix, "plan", local.suffix_unique])), 0, 40)
      dashes      = true
      slug        = "plan"
      min_length  = 1
      max_length  = 40
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9-]+$"
      description = "App Service Plan"
    } : null
    application_gateway = var.enabled_all || lookup(var.enabled, "application_gateway", false) ? {
      name        = substr(join("-", compact([local.prefix, "agw", local.suffix])), 0, 80)
      name_unique = substr(join("-", compact([local.prefix, "agw", local.suffix_unique])), 0, 80)
      dashes      = true
      slug        = "agw"
      min_length  = 1
      max_length  = 80
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9_]$"
      description = "Application Gateway"
    } : null
    application_insights = var.enabled_all || lookup(var.enabled, "application_insights", false) ? {
      name        = substr(join("-", compact([local.prefix, "appi", local.suffix])), 0, 260)
      name_unique = substr(join("-", compact([local.prefix, "appi", local.suffix_unique])), 0, 260)
      dashes      = true
      slug        = "appi"
      min_length  = 10
      max_length  = 260
      scope       = "resourceGroup"
      regex       = "^[^%\\&?/]+$"
      description = "Application Insights"
    } : null
    application_security_group = var.enabled_all || lookup(var.enabled, "application_security_group", false) ? {
      name        = substr(join("-", compact([local.prefix, "asg", local.suffix])), 0, 80)
      name_unique = substr(join("-", compact([local.prefix, "asg", local.suffix_unique])), 0, 80)
      dashes      = true
      slug        = "asg"
      min_length  = 1
      max_length  = 80
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9_]$"
      description = "Application Security Group"
    } : null
    automation_account = var.enabled_all || lookup(var.enabled, "automation_account", false) ? {
      name        = substr(join("-", compact([local.prefix, "aa", local.suffix])), 0, 50)
      name_unique = substr(join("-", compact([local.prefix, "aa", local.suffix_unique])), 0, 50)
      dashes      = true
      slug        = "aa"
      min_length  = 6
      max_length  = 50
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z][a-zA-Z0-9-]+[a-zA-Z0-9]$"
      description = "Automation Account"
    } : null
    automation_certificate = var.enabled_all || lookup(var.enabled, "automation_certificate", false) ? {
      name        = substr(join("-", compact([local.prefix, "aacert", local.suffix])), 0, 128)
      name_unique = substr(join("-", compact([local.prefix, "aacert", local.suffix_unique])), 0, 128)
      dashes      = true
      slug        = "aacert"
      min_length  = 1
      max_length  = 128
      scope       = "parent"
      regex       = "^[^<>*%:.?\\+\\/]+[^<>*%:.?\\+\\/ ]$"
      description = "Automation Certificate"
    } : null
    automation_credential = var.enabled_all || lookup(var.enabled, "automation_credential", false) ? {
      name        = substr(join("-", compact([local.prefix, "aacred", local.suffix])), 0, 128)
      name_unique = substr(join("-", compact([local.prefix, "aacred", local.suffix_unique])), 0, 128)
      dashes      = true
      slug        = "aacred"
      min_length  = 1
      max_length  = 128
      scope       = "parent"
      regex       = "^[^<>*%:.?\\+\\/]+[^<>*%:.?\\+\\/ ]$"
      description = "Automation Credential"
    } : null
    automation_runbook = var.enabled_all || lookup(var.enabled, "automation_runbook", false) ? {
      name        = substr(join("-", compact([local.prefix, "aacred", local.suffix])), 0, 63)
      name_unique = substr(join("-", compact([local.prefix, "aacred", local.suffix_unique])), 0, 63)
      dashes      = true
      slug        = "aacred"
      min_length  = 1
      max_length  = 63
      scope       = "parent"
      regex       = "^[a-zA-Z][a-zA-Z0-9-]+$"
      description = "Automation Runbook"
    } : null
    automation_schedule = var.enabled_all || lookup(var.enabled, "automation_schedule", false) ? {
      name        = substr(join("-", compact([local.prefix, "aasched", local.suffix])), 0, 128)
      name_unique = substr(join("-", compact([local.prefix, "aasched", local.suffix_unique])), 0, 128)
      dashes      = true
      slug        = "aasched"
      min_length  = 1
      max_length  = 128
      scope       = "parent"
      regex       = "^[^<>*%:.?\\+\\/]+[^<>*%:.?\\+\\/ ]$"
      description = "Automation Schedule"
    } : null
    automation_variable = var.enabled_all || lookup(var.enabled, "automation_variable", false) ? {
      name        = substr(join("-", compact([local.prefix, "aavar", local.suffix])), 0, 128)
      name_unique = substr(join("-", compact([local.prefix, "aavar", local.suffix_unique])), 0, 128)
      dashes      = true
      slug        = "aavar"
      min_length  = 1
      max_length  = 128
      scope       = "parent"
      regex       = "^[^<>*%:.?\\+\\/]+[^<>*%:.?\\+\\/ ]$"
      description = "Automation Variable"
    } : null
    availability_set = var.enabled_all || lookup(var.enabled, "availability_set", false) ? {
      name        = substr(join("-", compact([local.prefix, "avail", local.suffix])), 0, 80)
      name_unique = substr(join("-", compact([local.prefix, "avail", local.suffix_unique])), 0, 80)
      dashes      = true
      slug        = "avail"
      min_length  = 1
      max_length  = 80
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-_.]+[a-zA-Z0-9_]$"
      description = "Availability Set"
    } : null
    bastion_host = var.enabled_all || lookup(var.enabled, "bastion_host", false) ? {
      name        = substr(join("-", compact([local.prefix, "snap", local.suffix])), 0, 80)
      name_unique = substr(join("-", compact([local.prefix, "snap", local.suffix_unique])), 0, 80)
      dashes      = true
      slug        = "snap"
      min_length  = 1
      max_length  = 80
      scope       = "parent"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9_]$"
      description = "Bastion Host"
    } : null
    batch_account = var.enabled_all || lookup(var.enabled, "batch_account", false) ? {
      name        = substr(join("", compact([local.prefix_safe, "ba", local.suffix_safe])), 0, 24)
      name_unique = substr(join("", compact([local.prefix_safe, "ba", local.suffix_unique_safe])), 0, 24)
      dashes      = false
      slug        = "ba"
      min_length  = 3
      max_length  = 24
      scope       = "region"
      regex       = "^[a-z0-9]+$"
      description = "Batch Account"
    } : null
    batch_application = var.enabled_all || lookup(var.enabled, "batch_application", false) ? {
      name        = substr(join("-", compact([local.prefix, "baapp", local.suffix])), 0, 64)
      name_unique = substr(join("-", compact([local.prefix, "baapp", local.suffix_unique])), 0, 64)
      dashes      = true
      slug        = "baapp"
      min_length  = 1
      max_length  = 64
      scope       = "parent"
      regex       = "^[a-zA-Z0-9_-]+$"
      description = "Batch Application"
    } : null
    batch_certificate = var.enabled_all || lookup(var.enabled, "batch_certificate", false) ? {
      name        = substr(join("-", compact([local.prefix, "bacert", local.suffix])), 0, 45)
      name_unique = substr(join("-", compact([local.prefix, "bacert", local.suffix_unique])), 0, 45)
      dashes      = true
      slug        = "bacert"
      min_length  = 5
      max_length  = 45
      scope       = "parent"
      regex       = "^[a-zA-Z0-9_-]+$"
      description = "Batch Certificate"
    } : null
    batch_pool = var.enabled_all || lookup(var.enabled, "batch_pool", false) ? {
      name        = substr(join("-", compact([local.prefix, "bapool", local.suffix])), 0, 24)
      name_unique = substr(join("-", compact([local.prefix, "bapool", local.suffix_unique])), 0, 24)
      dashes      = true
      slug        = "bapool"
      min_length  = 3
      max_length  = 24
      scope       = "parent"
      regex       = "^[a-zA-Z0-9_-]+$"
      description = "Batch Pool"
    } : null
    bot_channel_directline = var.enabled_all || lookup(var.enabled, "bot_channel_directline", false) ? {
      name        = substr(join("-", compact([local.prefix, "botline", local.suffix])), 0, 64)
      name_unique = substr(join("-", compact([local.prefix, "botline", local.suffix_unique])), 0, 64)
      dashes      = true
      slug        = "botline"
      min_length  = 2
      max_length  = 64
      scope       = "parent"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-_.]+$"
      description = "Bot Channel Directline"
    } : null
    bot_channel_email = var.enabled_all || lookup(var.enabled, "bot_channel_email", false) ? {
      name        = substr(join("-", compact([local.prefix, "botmail", local.suffix])), 0, 64)
      name_unique = substr(join("-", compact([local.prefix, "botmail", local.suffix_unique])), 0, 64)
      dashes      = true
      slug        = "botmail"
      min_length  = 2
      max_length  = 64
      scope       = "parent"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-_.]+$"
      description = "Bot Channel Email"
    } : null
    bot_channel_ms_teams = var.enabled_all || lookup(var.enabled, "bot_channel_ms_teams", false) ? {
      name        = substr(join("-", compact([local.prefix, "botteams", local.suffix])), 0, 64)
      name_unique = substr(join("-", compact([local.prefix, "botteams", local.suffix_unique])), 0, 64)
      dashes      = true
      slug        = "botteams"
      min_length  = 2
      max_length  = 64
      scope       = "parent"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-_.]+$"
      description = "Bot Channel Ms Teams"
    } : null
    bot_channel_slack = var.enabled_all || lookup(var.enabled, "bot_channel_slack", false) ? {
      name        = substr(join("-", compact([local.prefix, "botslack", local.suffix])), 0, 64)
      name_unique = substr(join("-", compact([local.prefix, "botslack", local.suffix_unique])), 0, 64)
      dashes      = true
      slug        = "botslack"
      min_length  = 2
      max_length  = 64
      scope       = "parent"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-_.]+$"
      description = "Bot Channel Slack"
    } : null
    bot_channels_registration = var.enabled_all || lookup(var.enabled, "bot_channels_registration", false) ? {
      name        = substr(join("-", compact([local.prefix, "botchan", local.suffix])), 0, 64)
      name_unique = substr(join("-", compact([local.prefix, "botchan", local.suffix_unique])), 0, 64)
      dashes      = true
      slug        = "botchan"
      min_length  = 2
      max_length  = 64
      scope       = "parent"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-_.]+$"
      description = "Bot Channels Registration"
    } : null
    bot_connection = var.enabled_all || lookup(var.enabled, "bot_connection", false) ? {
      name        = substr(join("-", compact([local.prefix, "botcon", local.suffix])), 0, 64)
      name_unique = substr(join("-", compact([local.prefix, "botcon", local.suffix_unique])), 0, 64)
      dashes      = true
      slug        = "botcon"
      min_length  = 2
      max_length  = 64
      scope       = "parent"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-_.]+$"
      description = "Bot Connection"
    } : null
    bot_web_app = var.enabled_all || lookup(var.enabled, "bot_web_app", false) ? {
      name        = substr(join("-", compact([local.prefix, "bot", local.suffix])), 0, 64)
      name_unique = substr(join("-", compact([local.prefix, "bot", local.suffix_unique])), 0, 64)
      dashes      = true
      slug        = "bot"
      min_length  = 2
      max_length  = 64
      scope       = "global"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-_.]+$"
      description = "Bot Web App"
    } : null
    cdn_endpoint = var.enabled_all || lookup(var.enabled, "cdn_endpoint", false) ? {
      name        = substr(join("-", compact([local.prefix, "cdn", local.suffix])), 0, 50)
      name_unique = substr(join("-", compact([local.prefix, "cdn", local.suffix_unique])), 0, 50)
      dashes      = true
      slug        = "cdn"
      min_length  = 1
      max_length  = 50
      scope       = "global"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]$"
      description = "Cdn Endpoint"
    } : null
    cdn_profile = var.enabled_all || lookup(var.enabled, "cdn_profile", false) ? {
      name        = substr(join("-", compact([local.prefix, "cdnprof", local.suffix])), 0, 260)
      name_unique = substr(join("-", compact([local.prefix, "cdnprof", local.suffix_unique])), 0, 260)
      dashes      = true
      slug        = "cdnprof"
      min_length  = 1
      max_length  = 260
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]$"
      description = "Cdn Profile"
    } : null
    cognitive_account = var.enabled_all || lookup(var.enabled, "cognitive_account", false) ? {
      name        = substr(join("-", compact([local.prefix, "cog", local.suffix])), 0, 64)
      name_unique = substr(join("-", compact([local.prefix, "cog", local.suffix_unique])), 0, 64)
      dashes      = true
      slug        = "cog"
      min_length  = 2
      max_length  = 64
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-]+$"
      description = "Cognitive Account"
    } : null
    container_app = var.enabled_all || lookup(var.enabled, "container_app", false) ? {
      name        = substr(join("-", compact([local.prefix, "ca", local.suffix])), 0, 32)
      name_unique = substr(join("-", compact([local.prefix, "ca", local.suffix_unique])), 0, 32)
      dashes      = true
      slug        = "ca"
      min_length  = 1
      max_length  = 32
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]$"
      description = "Container App"
    } : null
    container_app_environment = var.enabled_all || lookup(var.enabled, "container_app_environment", false) ? {
      name        = substr(join("-", compact([local.prefix, "cae", local.suffix])), 0, 60)
      name_unique = substr(join("-", compact([local.prefix, "cae", local.suffix_unique])), 0, 60)
      dashes      = true
      slug        = "cae"
      min_length  = 1
      max_length  = 60
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]$"
      description = "Container App Environment"
    } : null
    container_group = var.enabled_all || lookup(var.enabled, "container_group", false) ? {
      name        = substr(join("-", compact([local.prefix, "cg", local.suffix])), 0, 63)
      name_unique = substr(join("-", compact([local.prefix, "cg", local.suffix_unique])), 0, 63)
      dashes      = true
      slug        = "cg"
      min_length  = 1
      max_length  = 63
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]$"
      description = "Container Group"
    } : null
    container_registry = var.enabled_all || lookup(var.enabled, "container_registry", false) ? {
      name        = substr(join("", compact([local.prefix_safe, "acr", local.suffix_safe])), 0, 63)
      name_unique = substr(join("", compact([local.prefix_safe, "acr", local.suffix_unique_safe])), 0, 63)
      dashes      = false
      slug        = "acr"
      min_length  = 1
      max_length  = 63
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9]+$"
      description = "Container Registry"
    } : null
    container_registry_webhook = var.enabled_all || lookup(var.enabled, "container_registry_webhook", false) ? {
      name        = substr(join("", compact([local.prefix_safe, "crwh", local.suffix_safe])), 0, 50)
      name_unique = substr(join("", compact([local.prefix_safe, "crwh", local.suffix_unique_safe])), 0, 50)
      dashes      = false
      slug        = "crwh"
      min_length  = 1
      max_length  = 50
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9]+$"
      description = "Container Registry Webhook"
    } : null
    cosmosdb_account = var.enabled_all || lookup(var.enabled, "cosmosdb_account", false) ? {
      name        = substr(join("-", compact([local.prefix, "cosmos", local.suffix])), 0, 63)
      name_unique = substr(join("-", compact([local.prefix, "cosmos", local.suffix_unique])), 0, 63)
      dashes      = true
      slug        = "cosmos"
      min_length  = 1
      max_length  = 63
      scope       = "resourceGroup"
      regex       = "^[a-z0-9][a-z0-9-_.]+[a-z0-9]$"
      description = "Cosmosdb Account"
    } : null
    cosmosdb_cassandra_cluster = var.enabled_all || lookup(var.enabled, "cosmosdb_cassandra_cluster", false) ? {
      name        = substr(join("-", compact([local.prefix, "mcc", local.suffix])), 0, 44)
      name_unique = substr(join("-", compact([local.prefix, "mcc", local.suffix_unique])), 0, 44)
      dashes      = true
      slug        = "mcc"
      min_length  = 1
      max_length  = 44
      scope       = "parent"
      regex       = "^[a-z0-9][a-zA-Z0-9-]+[a-z0-9]$"
      description = "Cosmosdb Cassandra Cluster"
    } : null
    cosmosdb_cassandra_datacenter = var.enabled_all || lookup(var.enabled, "cosmosdb_cassandra_datacenter", false) ? {
      name        = substr(join("-", compact([local.prefix, "mcdc", local.suffix])), 0, 44)
      name_unique = substr(join("-", compact([local.prefix, "mcdc", local.suffix_unique])), 0, 44)
      dashes      = true
      slug        = "mcdc"
      min_length  = 1
      max_length  = 44
      scope       = "parent"
      regex       = "^[a-z0-9][a-zA-Z0-9-]+[a-z0-9]$"
      description = "Cosmosdb Cassandra Datacenter"
    } : null
    cosmosdb_postgres = var.enabled_all || lookup(var.enabled, "cosmosdb_postgres", false) ? {
      name        = substr(join("-", compact([local.prefix, "cospos", local.suffix])), 0, 63)
      name_unique = substr(join("-", compact([local.prefix, "cospos", local.suffix_unique])), 0, 63)
      dashes      = true
      slug        = "cospos"
      min_length  = 1
      max_length  = 63
      scope       = "resourceGroup"
      regex       = "^[a-z0-9][a-z0-9-_.]+[a-z0-9]$"
      description = "Cosmosdb Postgres"
    } : null
    custom_provider = var.enabled_all || lookup(var.enabled, "custom_provider", false) ? {
      name        = substr(join("-", compact([local.prefix, "prov", local.suffix])), 0, 64)
      name_unique = substr(join("-", compact([local.prefix, "prov", local.suffix_unique])), 0, 64)
      dashes      = true
      slug        = "prov"
      min_length  = 3
      max_length  = 64
      scope       = "resourceGroup"
      regex       = "^[^&%?\\/]+[^&%.?\\/ ]$"
      description = "Custom Provider"
    } : null
    dashboard = var.enabled_all || lookup(var.enabled, "dashboard", false) ? {
      name        = substr(join("-", compact([local.prefix, "dsb", local.suffix])), 0, 160)
      name_unique = substr(join("-", compact([local.prefix, "dsb", local.suffix_unique])), 0, 160)
      dashes      = true
      slug        = "dsb"
      min_length  = 3
      max_length  = 160
      scope       = "parent"
      regex       = "^[a-zA-Z0-9-]+$"
      description = "Dashboard"
    } : null
    data_factory = var.enabled_all || lookup(var.enabled, "data_factory", false) ? {
      name        = substr(join("-", compact([local.prefix, "adf", local.suffix])), 0, 63)
      name_unique = substr(join("-", compact([local.prefix, "adf", local.suffix_unique])), 0, 63)
      dashes      = true
      slug        = "adf"
      min_length  = 3
      max_length  = 63
      scope       = "global"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]$"
      description = "Data Factory"
    } : null
    data_factory_dataset_mysql = var.enabled_all || lookup(var.enabled, "data_factory_dataset_mysql", false) ? {
      name        = substr(join("-", compact([local.prefix, "adfmysql", local.suffix])), 0, 260)
      name_unique = substr(join("-", compact([local.prefix, "adfmysql", local.suffix_unique])), 0, 260)
      dashes      = true
      slug        = "adfmysql"
      min_length  = 1
      max_length  = 260
      scope       = "parent"
      regex       = "^[a-zA-Z0-9][^<>*%:.?\\+\\/]+[a-zA-Z0-9]$"
      description = "Data Factory Dataset Mysql"
    } : null
    data_factory_dataset_postgresql = var.enabled_all || lookup(var.enabled, "data_factory_dataset_postgresql", false) ? {
      name        = substr(join("-", compact([local.prefix, "adfpsql", local.suffix])), 0, 260)
      name_unique = substr(join("-", compact([local.prefix, "adfpsql", local.suffix_unique])), 0, 260)
      dashes      = true
      slug        = "adfpsql"
      min_length  = 1
      max_length  = 260
      scope       = "parent"
      regex       = "^[a-zA-Z0-9][^<>*%:.?\\+\\/]+[a-zA-Z0-9]$"
      description = "Data Factory Dataset Postgresql"
    } : null
    data_factory_dataset_sql_server_table = var.enabled_all || lookup(var.enabled, "data_factory_dataset_sql_server_table", false) ? {
      name        = substr(join("-", compact([local.prefix, "adfmssql", local.suffix])), 0, 260)
      name_unique = substr(join("-", compact([local.prefix, "adfmssql", local.suffix_unique])), 0, 260)
      dashes      = true
      slug        = "adfmssql"
      min_length  = 1
      max_length  = 260
      scope       = "parent"
      regex       = "^[a-zA-Z0-9][^<>*%:.?\\+\\/]+[a-zA-Z0-9]$"
      description = "Data Factory Dataset Sql Server Table"
    } : null
    data_factory_integration_runtime_managed = var.enabled_all || lookup(var.enabled, "data_factory_integration_runtime_managed", false) ? {
      name        = substr(join("-", compact([local.prefix, "adfir", local.suffix])), 0, 63)
      name_unique = substr(join("-", compact([local.prefix, "adfir", local.suffix_unique])), 0, 63)
      dashes      = true
      slug        = "adfir"
      min_length  = 3
      max_length  = 63
      scope       = "parent"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]$"
      description = "Data Factory Integration Runtime Managed"
    } : null
    data_factory_linked_service_data_lake_storage_gen2 = var.enabled_all || lookup(var.enabled, "data_factory_linked_service_data_lake_storage_gen2", false) ? {
      name        = substr(join("-", compact([local.prefix, "adfsvst", local.suffix])), 0, 260)
      name_unique = substr(join("-", compact([local.prefix, "adfsvst", local.suffix_unique])), 0, 260)
      dashes      = true
      slug        = "adfsvst"
      min_length  = 1
      max_length  = 260
      scope       = "parent"
      regex       = "^[a-zA-Z0-9][^<>*%:.?\\+\\/]+$"
      description = "Data Factory Linked Service Data Lake Storage Gen2"
    } : null
    data_factory_linked_service_key_vault = var.enabled_all || lookup(var.enabled, "data_factory_linked_service_key_vault", false) ? {
      name        = substr(join("-", compact([local.prefix, "adfsvkv", local.suffix])), 0, 260)
      name_unique = substr(join("-", compact([local.prefix, "adfsvkv", local.suffix_unique])), 0, 260)
      dashes      = true
      slug        = "adfsvkv"
      min_length  = 1
      max_length  = 260
      scope       = "parent"
      regex       = "^[a-zA-Z0-9][^<>*%:.?\\+\\/]+$"
      description = "Data Factory Linked Service Key Vault"
    } : null
    data_factory_linked_service_mysql = var.enabled_all || lookup(var.enabled, "data_factory_linked_service_mysql", false) ? {
      name        = substr(join("-", compact([local.prefix, "adfsvmysql", local.suffix])), 0, 260)
      name_unique = substr(join("-", compact([local.prefix, "adfsvmysql", local.suffix_unique])), 0, 260)
      dashes      = true
      slug        = "adfsvmysql"
      min_length  = 1
      max_length  = 260
      scope       = "parent"
      regex       = "^[a-zA-Z0-9][^<>*%:.?\\+\\/]+$"
      description = "Data Factory Linked Service Mysql"
    } : null
    data_factory_linked_service_postgresql = var.enabled_all || lookup(var.enabled, "data_factory_linked_service_postgresql", false) ? {
      name        = substr(join("-", compact([local.prefix, "adfsvpsql", local.suffix])), 0, 260)
      name_unique = substr(join("-", compact([local.prefix, "adfsvpsql", local.suffix_unique])), 0, 260)
      dashes      = true
      slug        = "adfsvpsql"
      min_length  = 1
      max_length  = 260
      scope       = "parent"
      regex       = "^[a-zA-Z0-9][^<>*%:.?\\+\\/]+$"
      description = "Data Factory Linked Service Postgresql"
    } : null
    data_factory_linked_service_sql_server = var.enabled_all || lookup(var.enabled, "data_factory_linked_service_sql_server", false) ? {
      name        = substr(join("-", compact([local.prefix, "adfsvmssql", local.suffix])), 0, 260)
      name_unique = substr(join("-", compact([local.prefix, "adfsvmssql", local.suffix_unique])), 0, 260)
      dashes      = true
      slug        = "adfsvmssql"
      min_length  = 1
      max_length  = 260
      scope       = "parent"
      regex       = "^[a-zA-Z0-9][^<>*%:.?\\+\\/]+$"
      description = "Data Factory Linked Service Sql Server"
    } : null
    data_factory_pipeline = var.enabled_all || lookup(var.enabled, "data_factory_pipeline", false) ? {
      name        = substr(join("-", compact([local.prefix, "adfpl", local.suffix])), 0, 260)
      name_unique = substr(join("-", compact([local.prefix, "adfpl", local.suffix_unique])), 0, 260)
      dashes      = true
      slug        = "adfpl"
      min_length  = 1
      max_length  = 260
      scope       = "parent"
      regex       = "^[a-zA-Z0-9][^<>*%:.?\\+\\/]+[a-zA-Z0-9]$"
      description = "Data Factory Pipeline"
    } : null
    data_factory_trigger_schedule = var.enabled_all || lookup(var.enabled, "data_factory_trigger_schedule", false) ? {
      name        = substr(join("-", compact([local.prefix, "adftg", local.suffix])), 0, 260)
      name_unique = substr(join("-", compact([local.prefix, "adftg", local.suffix_unique])), 0, 260)
      dashes      = true
      slug        = "adftg"
      min_length  = 1
      max_length  = 260
      scope       = "parent"
      regex       = "^[a-zA-Z0-9][^<>*%:.?\\+\\/]+$"
      description = "Data Factory Trigger Schedule"
    } : null
    data_lake_analytics_account = var.enabled_all || lookup(var.enabled, "data_lake_analytics_account", false) ? {
      name        = substr(join("", compact([local.prefix_safe, "dla", local.suffix_safe])), 0, 24)
      name_unique = substr(join("", compact([local.prefix_safe, "dla", local.suffix_unique_safe])), 0, 24)
      dashes      = false
      slug        = "dla"
      min_length  = 3
      max_length  = 24
      scope       = "global"
      regex       = "^[a-z0-9]+$"
      description = "Data Lake Analytics Account"
    } : null
    data_lake_analytics_firewall_rule = var.enabled_all || lookup(var.enabled, "data_lake_analytics_firewall_rule", false) ? {
      name        = substr(join("-", compact([local.prefix, "dlfw", local.suffix])), 0, 50)
      name_unique = substr(join("-", compact([local.prefix, "dlfw", local.suffix_unique])), 0, 50)
      dashes      = true
      slug        = "dlfw"
      min_length  = 3
      max_length  = 50
      scope       = "parent"
      regex       = "^[a-z0-9-_]+$"
      description = "Data Lake Analytics Firewall Rule"
    } : null
    data_lake_store = var.enabled_all || lookup(var.enabled, "data_lake_store", false) ? {
      name        = substr(join("", compact([local.prefix_safe, "dls", local.suffix_safe])), 0, 24)
      name_unique = substr(join("", compact([local.prefix_safe, "dls", local.suffix_unique_safe])), 0, 24)
      dashes      = false
      slug        = "dls"
      min_length  = 3
      max_length  = 24
      scope       = "parent"
      regex       = "^[a-z0-9]+$"
      description = "Data Lake Store"
    } : null
    data_lake_store_firewall_rule = var.enabled_all || lookup(var.enabled, "data_lake_store_firewall_rule", false) ? {
      name        = substr(join("-", compact([local.prefix, "dlsfw", local.suffix])), 0, 50)
      name_unique = substr(join("-", compact([local.prefix, "dlsfw", local.suffix_unique])), 0, 50)
      dashes      = true
      slug        = "dlsfw"
      min_length  = 3
      max_length  = 50
      scope       = "parent"
      regex       = "^[a-zA-Z0-9-_]+$"
      description = "Data Lake Store Firewall Rule"
    } : null
    database_migration_project = var.enabled_all || lookup(var.enabled, "database_migration_project", false) ? {
      name        = substr(join("-", compact([local.prefix, "migr", local.suffix])), 0, 57)
      name_unique = substr(join("-", compact([local.prefix, "migr", local.suffix_unique])), 0, 57)
      dashes      = true
      slug        = "migr"
      min_length  = 2
      max_length  = 57
      scope       = "parent"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-_.]+$"
      description = "Database Migration Project"
    } : null
    database_migration_service = var.enabled_all || lookup(var.enabled, "database_migration_service", false) ? {
      name        = substr(join("-", compact([local.prefix, "dms", local.suffix])), 0, 62)
      name_unique = substr(join("-", compact([local.prefix, "dms", local.suffix_unique])), 0, 62)
      dashes      = true
      slug        = "dms"
      min_length  = 2
      max_length  = 62
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-_.]+$"
      description = "Database Migration Service"
    } : null
    databricks_cluster = var.enabled_all || lookup(var.enabled, "databricks_cluster", false) ? {
      name        = substr(join("-", compact([local.prefix, "dbc", local.suffix])), 0, 30)
      name_unique = substr(join("-", compact([local.prefix, "dbc", local.suffix_unique])), 0, 30)
      dashes      = true
      slug        = "dbc"
      min_length  = 3
      max_length  = 30
      scope       = "parent"
      regex       = "^[a-zA-Z0-9-_]+$"
      description = "Databricks Cluster"
    } : null
    databricks_high_concurrency_cluster = var.enabled_all || lookup(var.enabled, "databricks_high_concurrency_cluster", false) ? {
      name        = substr(join("-", compact([local.prefix, "dbhcc", local.suffix])), 0, 30)
      name_unique = substr(join("-", compact([local.prefix, "dbhcc", local.suffix_unique])), 0, 30)
      dashes      = true
      slug        = "dbhcc"
      min_length  = 3
      max_length  = 30
      scope       = "parent"
      regex       = "^[a-zA-Z0-9-_]+$"
      description = "Databricks High Concurrency Cluster"
    } : null
    databricks_standard_cluster = var.enabled_all || lookup(var.enabled, "databricks_standard_cluster", false) ? {
      name        = substr(join("-", compact([local.prefix, "dbsc", local.suffix])), 0, 30)
      name_unique = substr(join("-", compact([local.prefix, "dbsc", local.suffix_unique])), 0, 30)
      dashes      = true
      slug        = "dbsc"
      min_length  = 3
      max_length  = 30
      scope       = "parent"
      regex       = "^[a-zA-Z0-9-_]+$"
      description = "Databricks Standard Cluster"
    } : null
    databricks_workspace = var.enabled_all || lookup(var.enabled, "databricks_workspace", false) ? {
      name        = substr(join("-", compact([local.prefix, "dbw", local.suffix])), 0, 30)
      name_unique = substr(join("-", compact([local.prefix, "dbw", local.suffix_unique])), 0, 30)
      dashes      = true
      slug        = "dbw"
      min_length  = 3
      max_length  = 30
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9-_]+$"
      description = "Databricks Workspace"
    } : null
    dev_test_lab = var.enabled_all || lookup(var.enabled, "dev_test_lab", false) ? {
      name        = substr(join("-", compact([local.prefix, "lab", local.suffix])), 0, 50)
      name_unique = substr(join("-", compact([local.prefix, "lab", local.suffix_unique])), 0, 50)
      dashes      = true
      slug        = "lab"
      min_length  = 1
      max_length  = 50
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9-_]+$"
      description = "Dev Test Lab"
    } : null
    dev_test_linux_virtual_machine = var.enabled_all || lookup(var.enabled, "dev_test_linux_virtual_machine", false) ? {
      name        = substr(join("-", compact([local.prefix, "labvm", local.suffix])), 0, 64)
      name_unique = substr(join("-", compact([local.prefix, "labvm", local.suffix_unique])), 0, 64)
      dashes      = true
      slug        = "labvm"
      min_length  = 1
      max_length  = 64
      scope       = "parent"
      regex       = "^[a-zA-Z0-9-]+$"
      description = "Dev Test Linux Virtual Machine"
    } : null
    dev_test_windows_virtual_machine = var.enabled_all || lookup(var.enabled, "dev_test_windows_virtual_machine", false) ? {
      name        = substr(join("-", compact([local.prefix, "labvm", local.suffix])), 0, 15)
      name_unique = substr(join("-", compact([local.prefix, "labvm", local.suffix_unique])), 0, 15)
      dashes      = true
      slug        = "labvm"
      min_length  = 1
      max_length  = 15
      scope       = "parent"
      regex       = "^[a-zA-Z0-9-]+$"
      description = "Dev Test Windows Virtual Machine"
    } : null
    disk_encryption_set = var.enabled_all || lookup(var.enabled, "disk_encryption_set", false) ? {
      name        = substr(join("-", compact([local.prefix, "des", local.suffix])), 0, 80)
      name_unique = substr(join("-", compact([local.prefix, "des", local.suffix_unique])), 0, 80)
      dashes      = true
      slug        = "des"
      min_length  = 1
      max_length  = 80
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9_]+$"
      description = "Disk Encryption Set"
    } : null
    dns_a_record = var.enabled_all || lookup(var.enabled, "dns_a_record", false) ? {
      name        = substr(join("-", compact([local.prefix, "dnsrec", local.suffix])), 0, 80)
      name_unique = substr(join("-", compact([local.prefix, "dnsrec", local.suffix_unique])), 0, 80)
      dashes      = true
      slug        = "dnsrec"
      min_length  = 1
      max_length  = 80
      scope       = "parent"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9_]$"
      description = "Dns A Record"
    } : null
    dns_aaaa_record = var.enabled_all || lookup(var.enabled, "dns_aaaa_record", false) ? {
      name        = substr(join("-", compact([local.prefix, "dnsrec", local.suffix])), 0, 80)
      name_unique = substr(join("-", compact([local.prefix, "dnsrec", local.suffix_unique])), 0, 80)
      dashes      = true
      slug        = "dnsrec"
      min_length  = 1
      max_length  = 80
      scope       = "parent"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9_]$"
      description = "Dns Aaaa Record"
    } : null
    dns_caa_record = var.enabled_all || lookup(var.enabled, "dns_caa_record", false) ? {
      name        = substr(join("-", compact([local.prefix, "dnsrec", local.suffix])), 0, 80)
      name_unique = substr(join("-", compact([local.prefix, "dnsrec", local.suffix_unique])), 0, 80)
      dashes      = true
      slug        = "dnsrec"
      min_length  = 1
      max_length  = 80
      scope       = "parent"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9_]$"
      description = "Dns Caa Record"
    } : null
    dns_cname_record = var.enabled_all || lookup(var.enabled, "dns_cname_record", false) ? {
      name        = substr(join("-", compact([local.prefix, "dnsrec", local.suffix])), 0, 80)
      name_unique = substr(join("-", compact([local.prefix, "dnsrec", local.suffix_unique])), 0, 80)
      dashes      = true
      slug        = "dnsrec"
      min_length  = 1
      max_length  = 80
      scope       = "parent"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9_]$"
      description = "Dns Cname Record"
    } : null
    dns_mx_record = var.enabled_all || lookup(var.enabled, "dns_mx_record", false) ? {
      name        = substr(join("-", compact([local.prefix, "dnsrec", local.suffix])), 0, 80)
      name_unique = substr(join("-", compact([local.prefix, "dnsrec", local.suffix_unique])), 0, 80)
      dashes      = true
      slug        = "dnsrec"
      min_length  = 1
      max_length  = 80
      scope       = "parent"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9_]$"
      description = "Dns Mx Record"
    } : null
    dns_ns_record = var.enabled_all || lookup(var.enabled, "dns_ns_record", false) ? {
      name        = substr(join("-", compact([local.prefix, "dnsrec", local.suffix])), 0, 80)
      name_unique = substr(join("-", compact([local.prefix, "dnsrec", local.suffix_unique])), 0, 80)
      dashes      = true
      slug        = "dnsrec"
      min_length  = 1
      max_length  = 80
      scope       = "parent"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9_]$"
      description = "Dns Ns Record"
    } : null
    dns_ptr_record = var.enabled_all || lookup(var.enabled, "dns_ptr_record", false) ? {
      name        = substr(join("-", compact([local.prefix, "dnsrec", local.suffix])), 0, 80)
      name_unique = substr(join("-", compact([local.prefix, "dnsrec", local.suffix_unique])), 0, 80)
      dashes      = true
      slug        = "dnsrec"
      min_length  = 1
      max_length  = 80
      scope       = "parent"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9_]$"
      description = "Dns Ptr Record"
    } : null
    dns_txt_record = var.enabled_all || lookup(var.enabled, "dns_txt_record", false) ? {
      name        = substr(join("-", compact([local.prefix, "dnsrec", local.suffix])), 0, 80)
      name_unique = substr(join("-", compact([local.prefix, "dnsrec", local.suffix_unique])), 0, 80)
      dashes      = true
      slug        = "dnsrec"
      min_length  = 1
      max_length  = 80
      scope       = "parent"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9_]$"
      description = "Dns Txt Record"
    } : null
    dns_zone = var.enabled_all || lookup(var.enabled, "dns_zone", false) ? {
      name        = substr(join("-", compact([local.prefix, "dns", local.suffix])), 0, 63)
      name_unique = substr(join("-", compact([local.prefix, "dns", local.suffix_unique])), 0, 63)
      dashes      = true
      slug        = "dns"
      min_length  = 1
      max_length  = 63
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9_]$"
      description = "Dns Zone"
    } : null
    eventgrid_domain = var.enabled_all || lookup(var.enabled, "eventgrid_domain", false) ? {
      name        = substr(join("-", compact([local.prefix, "egd", local.suffix])), 0, 50)
      name_unique = substr(join("-", compact([local.prefix, "egd", local.suffix_unique])), 0, 50)
      dashes      = true
      slug        = "egd"
      min_length  = 3
      max_length  = 50
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9-]+$"
      description = "Eventgrid Domain"
    } : null
    eventgrid_domain_topic = var.enabled_all || lookup(var.enabled, "eventgrid_domain_topic", false) ? {
      name        = substr(join("-", compact([local.prefix, "egdt", local.suffix])), 0, 50)
      name_unique = substr(join("-", compact([local.prefix, "egdt", local.suffix_unique])), 0, 50)
      dashes      = true
      slug        = "egdt"
      min_length  = 3
      max_length  = 50
      scope       = "parent"
      regex       = "^[a-zA-Z0-9-]+$"
      description = "Eventgrid Domain Topic"
    } : null
    eventgrid_event_subscription = var.enabled_all || lookup(var.enabled, "eventgrid_event_subscription", false) ? {
      name        = substr(join("-", compact([local.prefix, "egs", local.suffix])), 0, 64)
      name_unique = substr(join("-", compact([local.prefix, "egs", local.suffix_unique])), 0, 64)
      dashes      = true
      slug        = "egs"
      min_length  = 3
      max_length  = 64
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9-]+$"
      description = "Eventgrid Event Subscription"
    } : null
    eventgrid_topic = var.enabled_all || lookup(var.enabled, "eventgrid_topic", false) ? {
      name        = substr(join("-", compact([local.prefix, "egt", local.suffix])), 0, 50)
      name_unique = substr(join("-", compact([local.prefix, "egt", local.suffix_unique])), 0, 50)
      dashes      = true
      slug        = "egt"
      min_length  = 3
      max_length  = 50
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9-]+$"
      description = "Eventgrid Topic"
    } : null
    eventhub = var.enabled_all || lookup(var.enabled, "eventhub", false) ? {
      name        = substr(join("-", compact([local.prefix, "evh", local.suffix])), 0, 50)
      name_unique = substr(join("-", compact([local.prefix, "evh", local.suffix_unique])), 0, 50)
      dashes      = true
      slug        = "evh"
      min_length  = 1
      max_length  = 50
      scope       = "parent"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9]$"
      description = "Eventhub"
    } : null
    eventhub_authorization_rule = var.enabled_all || lookup(var.enabled, "eventhub_authorization_rule", false) ? {
      name        = substr(join("-", compact([local.prefix, "ehar", local.suffix])), 0, 50)
      name_unique = substr(join("-", compact([local.prefix, "ehar", local.suffix_unique])), 0, 50)
      dashes      = true
      slug        = "ehar"
      min_length  = 1
      max_length  = 50
      scope       = "parent"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9]$"
      description = "Eventhub Authorization Rule"
    } : null
    eventhub_consumer_group = var.enabled_all || lookup(var.enabled, "eventhub_consumer_group", false) ? {
      name        = substr(join("-", compact([local.prefix, "ehcg", local.suffix])), 0, 50)
      name_unique = substr(join("-", compact([local.prefix, "ehcg", local.suffix_unique])), 0, 50)
      dashes      = true
      slug        = "ehcg"
      min_length  = 1
      max_length  = 50
      scope       = "parent"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9]$"
      description = "Eventhub Consumer Group"
    } : null
    eventhub_namespace = var.enabled_all || lookup(var.enabled, "eventhub_namespace", false) ? {
      name        = substr(join("-", compact([local.prefix, "ehn", local.suffix])), 0, 50)
      name_unique = substr(join("-", compact([local.prefix, "ehn", local.suffix_unique])), 0, 50)
      dashes      = true
      slug        = "ehn"
      min_length  = 1
      max_length  = 50
      scope       = "global"
      regex       = "^[a-zA-Z][a-zA-Z0-9-]+[a-zA-Z0-9]$"
      description = "Eventhub Namespace"
    } : null
    eventhub_namespace_authorization_rule = var.enabled_all || lookup(var.enabled, "eventhub_namespace_authorization_rule", false) ? {
      name        = substr(join("-", compact([local.prefix, "ehnar", local.suffix])), 0, 50)
      name_unique = substr(join("-", compact([local.prefix, "ehnar", local.suffix_unique])), 0, 50)
      dashes      = true
      slug        = "ehnar"
      min_length  = 1
      max_length  = 50
      scope       = "parent"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9]$"
      description = "Eventhub Namespace Authorization Rule"
    } : null
    eventhub_namespace_disaster_recovery_config = var.enabled_all || lookup(var.enabled, "eventhub_namespace_disaster_recovery_config", false) ? {
      name        = substr(join("-", compact([local.prefix, "ehdr", local.suffix])), 0, 50)
      name_unique = substr(join("-", compact([local.prefix, "ehdr", local.suffix_unique])), 0, 50)
      dashes      = true
      slug        = "ehdr"
      min_length  = 1
      max_length  = 50
      scope       = "parent"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9]$"
      description = "Eventhub Namespace Disaster Recovery Config"
    } : null
    express_route_circuit = var.enabled_all || lookup(var.enabled, "express_route_circuit", false) ? {
      name        = substr(join("-", compact([local.prefix, "erc", local.suffix])), 0, 80)
      name_unique = substr(join("-", compact([local.prefix, "erc", local.suffix_unique])), 0, 80)
      dashes      = true
      slug        = "erc"
      min_length  = 1
      max_length  = 80
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9_]$"
      description = "Express Route Circuit"
    } : null
    express_route_gateway = var.enabled_all || lookup(var.enabled, "express_route_gateway", false) ? {
      name        = substr(join("-", compact([local.prefix, "ergw", local.suffix])), 0, 80)
      name_unique = substr(join("-", compact([local.prefix, "ergw", local.suffix_unique])), 0, 80)
      dashes      = true
      slug        = "ergw"
      min_length  = 1
      max_length  = 80
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9_]$"
      description = "Express Route Gateway"
    } : null
    firewall = var.enabled_all || lookup(var.enabled, "firewall", false) ? {
      name        = substr(join("-", compact([local.prefix, "fw", local.suffix])), 0, 80)
      name_unique = substr(join("-", compact([local.prefix, "fw", local.suffix_unique])), 0, 80)
      dashes      = true
      slug        = "fw"
      min_length  = 1
      max_length  = 80
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9_]$"
      description = "Firewall"
    } : null
    firewall_application_rule_collection = var.enabled_all || lookup(var.enabled, "firewall_application_rule_collection", false) ? {
      name        = substr(join("-", compact([local.prefix, "fwapp", local.suffix])), 0, 80)
      name_unique = substr(join("-", compact([local.prefix, "fwapp", local.suffix_unique])), 0, 80)
      dashes      = true
      slug        = "fwapp"
      min_length  = 1
      max_length  = 80
      scope       = "parent"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9\\-\\._]+[a-zA-Z0-9_]$"
      description = "Firewall Application Rule Collection"
    } : null
    firewall_ip_configuration = var.enabled_all || lookup(var.enabled, "firewall_ip_configuration", false) ? {
      name        = substr(join("-", compact([local.prefix, "fwipconf", local.suffix])), 0, 80)
      name_unique = substr(join("-", compact([local.prefix, "fwipconf", local.suffix_unique])), 0, 80)
      dashes      = true
      slug        = "fwipconf"
      min_length  = 1
      max_length  = 80
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9\\-\\._]+[a-zA-Z0-9_]$"
      description = "Firewall Ip Configuration"
    } : null
    firewall_nat_rule_collection = var.enabled_all || lookup(var.enabled, "firewall_nat_rule_collection", false) ? {
      name        = substr(join("-", compact([local.prefix, "fwnatrc", local.suffix])), 0, 80)
      name_unique = substr(join("-", compact([local.prefix, "fwnatrc", local.suffix_unique])), 0, 80)
      dashes      = true
      slug        = "fwnatrc"
      min_length  = 1
      max_length  = 80
      scope       = "parent"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9\\-\\._]+[a-zA-Z0-9_]$"
      description = "Firewall Nat Rule Collection"
    } : null
    firewall_network_rule_collection = var.enabled_all || lookup(var.enabled, "firewall_network_rule_collection", false) ? {
      name        = substr(join("-", compact([local.prefix, "fwnetrc", local.suffix])), 0, 80)
      name_unique = substr(join("-", compact([local.prefix, "fwnetrc", local.suffix_unique])), 0, 80)
      dashes      = true
      slug        = "fwnetrc"
      min_length  = 1
      max_length  = 80
      scope       = "parent"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9\\-\\._]+[a-zA-Z0-9_]$"
      description = "Firewall Network Rule Collection"
    } : null
    firewall_policy = var.enabled_all || lookup(var.enabled, "firewall_policy", false) ? {
      name        = substr(join("-", compact([local.prefix, "afwp", local.suffix])), 0, 80)
      name_unique = substr(join("-", compact([local.prefix, "afwp", local.suffix_unique])), 0, 80)
      dashes      = true
      slug        = "afwp"
      min_length  = 1
      max_length  = 80
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9_]$"
      description = "Firewall Policy"
    } : null
    firewall_policy_rule_collection_group = var.enabled_all || lookup(var.enabled, "firewall_policy_rule_collection_group", false) ? {
      name        = substr(join("-", compact([local.prefix, "fwprcg", local.suffix])), 0, 80)
      name_unique = substr(join("-", compact([local.prefix, "fwprcg", local.suffix_unique])), 0, 80)
      dashes      = true
      slug        = "fwprcg"
      min_length  = 1
      max_length  = 80
      scope       = "parent"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9\\-\\._]+[a-zA-Z0-9_]$"
      description = "Firewall Policy Rule Collection Group"
    } : null
    frontdoor = var.enabled_all || lookup(var.enabled, "frontdoor", false) ? {
      name        = substr(join("-", compact([local.prefix, "fd", local.suffix])), 0, 64)
      name_unique = substr(join("-", compact([local.prefix, "fd", local.suffix_unique])), 0, 64)
      dashes      = true
      slug        = "fd"
      min_length  = 5
      max_length  = 64
      scope       = "global"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]$"
      description = "Frontdoor"
    } : null
    frontdoor_firewall_policy = var.enabled_all || lookup(var.enabled, "frontdoor_firewall_policy", false) ? {
      name        = substr(join("-", compact([local.prefix, "fdfw", local.suffix])), 0, 80)
      name_unique = substr(join("-", compact([local.prefix, "fdfw", local.suffix_unique])), 0, 80)
      dashes      = true
      slug        = "fdfw"
      min_length  = 1
      max_length  = 80
      scope       = "global"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9_]$"
      description = "Frontdoor Firewall Policy"
    } : null
    function_app = var.enabled_all || lookup(var.enabled, "function_app", false) ? {
      name        = substr(join("-", compact([local.prefix, "func", local.suffix])), 0, 60)
      name_unique = substr(join("-", compact([local.prefix, "func", local.suffix_unique])), 0, 60)
      dashes      = true
      slug        = "func"
      min_length  = 2
      max_length  = 60
      scope       = "global"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]$"
      description = "Function App"
    } : null
    hdinsight_hadoop_cluster = var.enabled_all || lookup(var.enabled, "hdinsight_hadoop_cluster", false) ? {
      name        = substr(join("-", compact([local.prefix, "hadoop", local.suffix])), 0, 59)
      name_unique = substr(join("-", compact([local.prefix, "hadoop", local.suffix_unique])), 0, 59)
      dashes      = true
      slug        = "hadoop"
      min_length  = 3
      max_length  = 59
      scope       = "global"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]$"
      description = "Hdinsight Hadoop Cluster"
    } : null
    hdinsight_hbase_cluster = var.enabled_all || lookup(var.enabled, "hdinsight_hbase_cluster", false) ? {
      name        = substr(join("-", compact([local.prefix, "hbase", local.suffix])), 0, 59)
      name_unique = substr(join("-", compact([local.prefix, "hbase", local.suffix_unique])), 0, 59)
      dashes      = true
      slug        = "hbase"
      min_length  = 3
      max_length  = 59
      scope       = "global"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]$"
      description = "Hdinsight Hbase Cluster"
    } : null
    hdinsight_interactive_query_cluster = var.enabled_all || lookup(var.enabled, "hdinsight_interactive_query_cluster", false) ? {
      name        = substr(join("-", compact([local.prefix, "iqr", local.suffix])), 0, 59)
      name_unique = substr(join("-", compact([local.prefix, "iqr", local.suffix_unique])), 0, 59)
      dashes      = true
      slug        = "iqr"
      min_length  = 3
      max_length  = 59
      scope       = "global"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]$"
      description = "Hdinsight Interactive Query Cluster"
    } : null
    hdinsight_kafka_cluster = var.enabled_all || lookup(var.enabled, "hdinsight_kafka_cluster", false) ? {
      name        = substr(join("-", compact([local.prefix, "kafka", local.suffix])), 0, 59)
      name_unique = substr(join("-", compact([local.prefix, "kafka", local.suffix_unique])), 0, 59)
      dashes      = true
      slug        = "kafka"
      min_length  = 3
      max_length  = 59
      scope       = "global"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]$"
      description = "Hdinsight Kafka Cluster"
    } : null
    hdinsight_ml_services_cluster = var.enabled_all || lookup(var.enabled, "hdinsight_ml_services_cluster", false) ? {
      name        = substr(join("-", compact([local.prefix, "mls", local.suffix])), 0, 59)
      name_unique = substr(join("-", compact([local.prefix, "mls", local.suffix_unique])), 0, 59)
      dashes      = true
      slug        = "mls"
      min_length  = 3
      max_length  = 59
      scope       = "global"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]$"
      description = "Hdinsight Ml Services Cluster"
    } : null
    hdinsight_rserver_cluster = var.enabled_all || lookup(var.enabled, "hdinsight_rserver_cluster", false) ? {
      name        = substr(join("-", compact([local.prefix, "rsv", local.suffix])), 0, 59)
      name_unique = substr(join("-", compact([local.prefix, "rsv", local.suffix_unique])), 0, 59)
      dashes      = true
      slug        = "rsv"
      min_length  = 3
      max_length  = 59
      scope       = "global"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]$"
      description = "Hdinsight Rserver Cluster"
    } : null
    hdinsight_spark_cluster = var.enabled_all || lookup(var.enabled, "hdinsight_spark_cluster", false) ? {
      name        = substr(join("-", compact([local.prefix, "spark", local.suffix])), 0, 59)
      name_unique = substr(join("-", compact([local.prefix, "spark", local.suffix_unique])), 0, 59)
      dashes      = true
      slug        = "spark"
      min_length  = 3
      max_length  = 59
      scope       = "global"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]$"
      description = "Hdinsight Spark Cluster"
    } : null
    hdinsight_storm_cluster = var.enabled_all || lookup(var.enabled, "hdinsight_storm_cluster", false) ? {
      name        = substr(join("-", compact([local.prefix, "storm", local.suffix])), 0, 59)
      name_unique = substr(join("-", compact([local.prefix, "storm", local.suffix_unique])), 0, 59)
      dashes      = true
      slug        = "storm"
      min_length  = 3
      max_length  = 59
      scope       = "global"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]$"
      description = "Hdinsight Storm Cluster"
    } : null
    image = var.enabled_all || lookup(var.enabled, "image", false) ? {
      name        = substr(join("-", compact([local.prefix, "img", local.suffix])), 0, 80)
      name_unique = substr(join("-", compact([local.prefix, "img", local.suffix_unique])), 0, 80)
      dashes      = true
      slug        = "img"
      min_length  = 1
      max_length  = 80
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-_.]+[a-zA-Z0-9_]$"
      description = "Image"
    } : null
    iotcentral_application = var.enabled_all || lookup(var.enabled, "iotcentral_application", false) ? {
      name        = substr(join("-", compact([local.prefix, "iotapp", local.suffix])), 0, 63)
      name_unique = substr(join("-", compact([local.prefix, "iotapp", local.suffix_unique])), 0, 63)
      dashes      = true
      slug        = "iotapp"
      min_length  = 2
      max_length  = 63
      scope       = "global"
      regex       = "^[a-z0-9][a-z0-9-]+[a-z0-9]$"
      description = "Iotcentral Application"
    } : null
    iothub = var.enabled_all || lookup(var.enabled, "iothub", false) ? {
      name        = substr(join("-", compact([local.prefix, "iot", local.suffix])), 0, 50)
      name_unique = substr(join("-", compact([local.prefix, "iot", local.suffix_unique])), 0, 50)
      dashes      = true
      slug        = "iot"
      min_length  = 3
      max_length  = 50
      scope       = "global"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-]+[a-z0-9]$"
      description = "Iothub"
    } : null
    iothub_consumer_group = var.enabled_all || lookup(var.enabled, "iothub_consumer_group", false) ? {
      name        = substr(join("-", compact([local.prefix, "iotcg", local.suffix])), 0, 50)
      name_unique = substr(join("-", compact([local.prefix, "iotcg", local.suffix_unique])), 0, 50)
      dashes      = true
      slug        = "iotcg"
      min_length  = 1
      max_length  = 50
      scope       = "parent"
      regex       = "^[a-zA-Z0-9-._]+$"
      description = "Iothub Consumer Group"
    } : null
    iothub_dps = var.enabled_all || lookup(var.enabled, "iothub_dps", false) ? {
      name        = substr(join("-", compact([local.prefix, "dps", local.suffix])), 0, 64)
      name_unique = substr(join("-", compact([local.prefix, "dps", local.suffix_unique])), 0, 64)
      dashes      = true
      slug        = "dps"
      min_length  = 3
      max_length  = 64
      scope       = "resoureceGroup"
      regex       = "^[a-zA-Z0-9-]+[a-zA-Z0-9]$"
      description = "Iothub Dps"
    } : null
    iothub_dps_certificate = var.enabled_all || lookup(var.enabled, "iothub_dps_certificate", false) ? {
      name        = substr(join("-", compact([local.prefix, "dpscert", local.suffix])), 0, 64)
      name_unique = substr(join("-", compact([local.prefix, "dpscert", local.suffix_unique])), 0, 64)
      dashes      = true
      slug        = "dpscert"
      min_length  = 1
      max_length  = 64
      scope       = "parent"
      regex       = "^[a-zA-Z0-9-._]+$"
      description = "Iothub Dps Certificate"
    } : null
    key_vault = var.enabled_all || lookup(var.enabled, "key_vault", false) ? {
      name        = substr(join("-", compact([local.prefix, "kv", local.suffix])), 0, 24)
      name_unique = substr(join("-", compact([local.prefix, "kv", local.suffix_unique])), 0, 24)
      dashes      = true
      slug        = "kv"
      min_length  = 3
      max_length  = 24
      scope       = "global"
      regex       = "^[a-zA-Z][a-zA-Z0-9-]+[a-zA-Z0-9]$"
      description = "Key Vault"
    } : null
    key_vault_certificate = var.enabled_all || lookup(var.enabled, "key_vault_certificate", false) ? {
      name        = substr(join("-", compact([local.prefix, "kvc", local.suffix])), 0, 127)
      name_unique = substr(join("-", compact([local.prefix, "kvc", local.suffix_unique])), 0, 127)
      dashes      = true
      slug        = "kvc"
      min_length  = 1
      max_length  = 127
      scope       = "parent"
      regex       = "^[a-zA-Z0-9-]+$"
      description = "Key Vault Certificate"
    } : null
    key_vault_key = var.enabled_all || lookup(var.enabled, "key_vault_key", false) ? {
      name        = substr(join("-", compact([local.prefix, "kvk", local.suffix])), 0, 127)
      name_unique = substr(join("-", compact([local.prefix, "kvk", local.suffix_unique])), 0, 127)
      dashes      = true
      slug        = "kvk"
      min_length  = 1
      max_length  = 127
      scope       = "parent"
      regex       = "^[a-zA-Z0-9-]+$"
      description = "Key Vault Key"
    } : null
    key_vault_secret = var.enabled_all || lookup(var.enabled, "key_vault_secret", false) ? {
      name        = substr(join("-", compact([local.prefix, "kvs", local.suffix])), 0, 127)
      name_unique = substr(join("-", compact([local.prefix, "kvs", local.suffix_unique])), 0, 127)
      dashes      = true
      slug        = "kvs"
      min_length  = 1
      max_length  = 127
      scope       = "parent"
      regex       = "^[a-zA-Z0-9-]+$"
      description = "Key Vault Secret"
    } : null
    kubernetes_cluster = var.enabled_all || lookup(var.enabled, "kubernetes_cluster", false) ? {
      name        = substr(join("-", compact([local.prefix, "aks", local.suffix])), 0, 63)
      name_unique = substr(join("-", compact([local.prefix, "aks", local.suffix_unique])), 0, 63)
      dashes      = true
      slug        = "aks"
      min_length  = 1
      max_length  = 63
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-_.]+[a-zA-Z0-9]$"
      description = "Kubernetes Cluster"
    } : null
    kusto_cluster = var.enabled_all || lookup(var.enabled, "kusto_cluster", false) ? {
      name        = substr(join("", compact([local.prefix_safe, "kc", local.suffix_safe])), 0, 22)
      name_unique = substr(join("", compact([local.prefix_safe, "kc", local.suffix_unique_safe])), 0, 22)
      dashes      = false
      slug        = "kc"
      min_length  = 4
      max_length  = 22
      scope       = "global"
      regex       = "^[a-z][a-z0-9]+$"
      description = "Kusto Cluster"
    } : null
    kusto_database = var.enabled_all || lookup(var.enabled, "kusto_database", false) ? {
      name        = substr(join("-", compact([local.prefix, "kdb", local.suffix])), 0, 260)
      name_unique = substr(join("-", compact([local.prefix, "kdb", local.suffix_unique])), 0, 260)
      dashes      = true
      slug        = "kdb"
      min_length  = 1
      max_length  = 260
      scope       = "parent"
      regex       = "^[a-zA-Z0-9- .]+$"
      description = "Kusto Database"
    } : null
    kusto_eventhub_data_connection = var.enabled_all || lookup(var.enabled, "kusto_eventhub_data_connection", false) ? {
      name        = substr(join("-", compact([local.prefix, "kehc", local.suffix])), 0, 40)
      name_unique = substr(join("-", compact([local.prefix, "kehc", local.suffix_unique])), 0, 40)
      dashes      = true
      slug        = "kehc"
      min_length  = 1
      max_length  = 40
      scope       = "parent"
      regex       = "^[a-zA-Z0-9- .]+$"
      description = "Kusto Eventhub Data Connection"
    } : null
    lb = var.enabled_all || lookup(var.enabled, "lb", false) ? {
      name        = substr(join("-", compact([local.prefix, "lb", local.suffix])), 0, 80)
      name_unique = substr(join("-", compact([local.prefix, "lb", local.suffix_unique])), 0, 80)
      dashes      = true
      slug        = "lb"
      min_length  = 1
      max_length  = 80
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9_]$"
      description = "Lb"
    } : null
    lb_nat_rule = var.enabled_all || lookup(var.enabled, "lb_nat_rule", false) ? {
      name        = substr(join("-", compact([local.prefix, "lbnatrl", local.suffix])), 0, 80)
      name_unique = substr(join("-", compact([local.prefix, "lbnatrl", local.suffix_unique])), 0, 80)
      dashes      = true
      slug        = "lbnatrl"
      min_length  = 1
      max_length  = 80
      scope       = "parent"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9_]$"
      description = "Lb Nat Rule"
    } : null
    linux_virtual_machine = var.enabled_all || lookup(var.enabled, "linux_virtual_machine", false) ? {
      name        = substr(join("-", compact([local.prefix, "vm", local.suffix])), 0, 64)
      name_unique = substr(join("-", compact([local.prefix, "vm", local.suffix_unique])), 0, 64)
      dashes      = true
      slug        = "vm"
      min_length  = 1
      max_length  = 64
      scope       = "resourceGroup"
      regex       = "^[^\\/\"\\[\\]:|<>+=;,?*@&_][^\\/\"\\[\\]:|<>+=;,?*@&]+[^\\/\"\\[\\]:|<>+=;,?*@&.-]$"
      description = "Linux Virtual Machine"
    } : null
    linux_virtual_machine_scale_set = var.enabled_all || lookup(var.enabled, "linux_virtual_machine_scale_set", false) ? {
      name        = substr(join("-", compact([local.prefix, "vmss", local.suffix])), 0, 64)
      name_unique = substr(join("-", compact([local.prefix, "vmss", local.suffix_unique])), 0, 64)
      dashes      = true
      slug        = "vmss"
      min_length  = 1
      max_length  = 64
      scope       = "resourceGroup"
      regex       = "^[^\\/\"\\[\\]:|<>+=;,?*@&_][^\\/\"\\[\\]:|<>+=;,?*@&]+[^\\/\"\\[\\]:|<>+=;,?*@&.-]$"
      description = "Linux Virtual Machine Scale Set"
    } : null
    load_test = var.enabled_all || lookup(var.enabled, "load_test", false) ? {
      name        = substr(join("-", compact([local.prefix, "lt", local.suffix])), 0, 64)
      name_unique = substr(join("-", compact([local.prefix, "lt", local.suffix_unique])), 0, 64)
      dashes      = true
      slug        = "lt"
      min_length  = 1
      max_length  = 64
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z][a-zA-Z0-9-_]{0,62}[a-zA-Z0-9|]$"
      description = "Load Test"
    } : null
    local_network_gateway = var.enabled_all || lookup(var.enabled, "local_network_gateway", false) ? {
      name        = substr(join("-", compact([local.prefix, "lgw", local.suffix])), 0, 80)
      name_unique = substr(join("-", compact([local.prefix, "lgw", local.suffix_unique])), 0, 80)
      dashes      = true
      slug        = "lgw"
      min_length  = 1
      max_length  = 80
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9_]$"
      description = "Local Network Gateway"
    } : null
    log_analytics_workspace = var.enabled_all || lookup(var.enabled, "log_analytics_workspace", false) ? {
      name        = substr(join("-", compact([local.prefix, "log", local.suffix])), 0, 63)
      name_unique = substr(join("-", compact([local.prefix, "log", local.suffix_unique])), 0, 63)
      dashes      = true
      slug        = "log"
      min_length  = 4
      max_length  = 63
      scope       = "parent"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]$"
      description = "Log Analytics Workspace"
    } : null
    logic_app_workflow = var.enabled_all || lookup(var.enabled, "logic_app_workflow", false) ? {
      name        = substr(join("-", compact([local.prefix, "logic", local.suffix])), 0, 80)
      name_unique = substr(join("-", compact([local.prefix, "logic", local.suffix_unique])), 0, 80)
      dashes      = true
      slug        = "logic"
      min_length  = 1
      max_length  = 80
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9_]$"
      description = "Logic App Workflow"
    } : null
    machine_learning_workspace = var.enabled_all || lookup(var.enabled, "machine_learning_workspace", false) ? {
      name        = substr(join("-", compact([local.prefix, "mlw", local.suffix])), 0, 260)
      name_unique = substr(join("-", compact([local.prefix, "mlw", local.suffix_unique])), 0, 260)
      dashes      = true
      slug        = "mlw"
      min_length  = 1
      max_length  = 260
      scope       = "resourceGroup"
      regex       = "^[^<>*%:.?\\+\\/]+[^<>*%:.?\\+\\/ ]$"
      description = "Machine Learning Workspace"
    } : null
    managed_disk = var.enabled_all || lookup(var.enabled, "managed_disk", false) ? {
      name        = substr(join("-", compact([local.prefix, "dsk", local.suffix])), 0, 80)
      name_unique = substr(join("-", compact([local.prefix, "dsk", local.suffix_unique])), 0, 80)
      dashes      = true
      slug        = "dsk"
      min_length  = 1
      max_length  = 80
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9_]+$"
      description = "Managed Disk"
    } : null
    management_lock = var.enabled_all || lookup(var.enabled, "management_lock", false) ? {
      name        = substr(join("-", compact([local.prefix, "mgmlck", local.suffix])), 0, 260)
      name_unique = substr(join("-", compact([local.prefix, "mgmlck", local.suffix_unique])), 0, 260)
      dashes      = true
      slug        = "mgmlck"
      min_length  = 1
      max_length  = 260
      scope       = "parent"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9_]$"
      description = "Management Lock"
    } : null
    maps_account = var.enabled_all || lookup(var.enabled, "maps_account", false) ? {
      name        = substr(join("-", compact([local.prefix, "map", local.suffix])), 0, 98)
      name_unique = substr(join("-", compact([local.prefix, "map", local.suffix_unique])), 0, 98)
      dashes      = true
      slug        = "map"
      min_length  = 1
      max_length  = 98
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+$"
      description = "Maps Account"
    } : null
    mariadb_database = var.enabled_all || lookup(var.enabled, "mariadb_database", false) ? {
      name        = substr(join("-", compact([local.prefix, "mariadb", local.suffix])), 0, 63)
      name_unique = substr(join("-", compact([local.prefix, "mariadb", local.suffix_unique])), 0, 63)
      dashes      = true
      slug        = "mariadb"
      min_length  = 1
      max_length  = 63
      scope       = "parent"
      regex       = "^[a-zA-Z0-9-_]+$"
      description = "Mariadb Database"
    } : null
    mariadb_firewall_rule = var.enabled_all || lookup(var.enabled, "mariadb_firewall_rule", false) ? {
      name        = substr(join("-", compact([local.prefix, "mariafw", local.suffix])), 0, 128)
      name_unique = substr(join("-", compact([local.prefix, "mariafw", local.suffix_unique])), 0, 128)
      dashes      = true
      slug        = "mariafw"
      min_length  = 1
      max_length  = 128
      scope       = "parent"
      regex       = "^[a-zA-Z0-9-_]+$"
      description = "Mariadb Firewall Rule"
    } : null
    mariadb_server = var.enabled_all || lookup(var.enabled, "mariadb_server", false) ? {
      name        = substr(join("-", compact([local.prefix, "maria", local.suffix])), 0, 63)
      name_unique = substr(join("-", compact([local.prefix, "maria", local.suffix_unique])), 0, 63)
      dashes      = true
      slug        = "maria"
      min_length  = 3
      max_length  = 63
      scope       = "global"
      regex       = "^[a-z0-9][a-zA-Z0-9-]+[a-z0-9]$"
      description = "Mariadb Server"
    } : null
    mariadb_virtual_network_rule = var.enabled_all || lookup(var.enabled, "mariadb_virtual_network_rule", false) ? {
      name        = substr(join("-", compact([local.prefix, "mariavn", local.suffix])), 0, 128)
      name_unique = substr(join("-", compact([local.prefix, "mariavn", local.suffix_unique])), 0, 128)
      dashes      = true
      slug        = "mariavn"
      min_length  = 1
      max_length  = 128
      scope       = "parent"
      regex       = "^[a-zA-Z0-9-_]+$"
      description = "Mariadb Virtual Network Rule"
    } : null
    monitor_action_group = var.enabled_all || lookup(var.enabled, "monitor_action_group", false) ? {
      name        = substr(join("-", compact([local.prefix, "mag", local.suffix])), 0, 260)
      name_unique = substr(join("-", compact([local.prefix, "mag", local.suffix_unique])), 0, 260)
      dashes      = true
      slug        = "mag"
      min_length  = 1
      max_length  = 260
      scope       = "resourceGroup"
      regex       = "^[^%&?\\+\\/]+[^^%&?\\+\\/ ]$"
      description = "Monitor Action Group"
    } : null
    monitor_autoscale_setting = var.enabled_all || lookup(var.enabled, "monitor_autoscale_setting", false) ? {
      name        = substr(join("-", compact([local.prefix, "mas", local.suffix])), 0, 260)
      name_unique = substr(join("-", compact([local.prefix, "mas", local.suffix_unique])), 0, 260)
      dashes      = true
      slug        = "mas"
      min_length  = 1
      max_length  = 260
      scope       = "resourceGroup"
      regex       = "^[^<>%&#.,?\\+\\/]+[^<>%&#.,?\\+\\/ ]$"
      description = "Monitor Autoscale Setting"
    } : null
    monitor_diagnostic_setting = var.enabled_all || lookup(var.enabled, "monitor_diagnostic_setting", false) ? {
      name        = substr(join("-", compact([local.prefix, "mds", local.suffix])), 0, 260)
      name_unique = substr(join("-", compact([local.prefix, "mds", local.suffix_unique])), 0, 260)
      dashes      = true
      slug        = "mds"
      min_length  = 1
      max_length  = 260
      scope       = "resourceGroup"
      regex       = "^[^*<>%:&?\\+\\/]+[^*<>%:&?\\+\\/ ]$"
      description = "Monitor Diagnostic Setting"
    } : null
    monitor_scheduled_query_rules_alert = var.enabled_all || lookup(var.enabled, "monitor_scheduled_query_rules_alert", false) ? {
      name        = substr(join("-", compact([local.prefix, "msqa", local.suffix])), 0, 260)
      name_unique = substr(join("-", compact([local.prefix, "msqa", local.suffix_unique])), 0, 260)
      dashes      = true
      slug        = "msqa"
      min_length  = 1
      max_length  = 260
      scope       = "resourceGroup"
      regex       = "^[^*<>%:{}&#.,?\\+\\/]+[^*<>%:{}&#.,?\\+\\/ ]$"
      description = "Monitor Scheduled Query Rules Alert"
    } : null
    mssql_database = var.enabled_all || lookup(var.enabled, "mssql_database", false) ? {
      name        = substr(join("-", compact([local.prefix, "sqldb", local.suffix])), 0, 128)
      name_unique = substr(join("-", compact([local.prefix, "sqldb", local.suffix_unique])), 0, 128)
      dashes      = true
      slug        = "sqldb"
      min_length  = 1
      max_length  = 128
      scope       = "parent"
      regex       = "^[^<>*%:.?\\+\\/]+[^<>*%:.?\\+\\/ ]$"
      description = "Mssql Database"
    } : null
    mssql_elasticpool = var.enabled_all || lookup(var.enabled, "mssql_elasticpool", false) ? {
      name        = substr(join("-", compact([local.prefix, "sqlep", local.suffix])), 0, 128)
      name_unique = substr(join("-", compact([local.prefix, "sqlep", local.suffix_unique])), 0, 128)
      dashes      = true
      slug        = "sqlep"
      min_length  = 1
      max_length  = 128
      scope       = "parent"
      regex       = "^[^<>*%:.?\\+\\/]+[^<>*%:.?\\+\\/ ]$"
      description = "Mssql Elasticpool"
    } : null
    mssql_managed_instance = var.enabled_all || lookup(var.enabled, "mssql_managed_instance", false) ? {
      name        = substr(join("-", compact([local.prefix, "sqlmi", local.suffix])), 0, 63)
      name_unique = substr(join("-", compact([local.prefix, "sqlmi", local.suffix_unique])), 0, 63)
      dashes      = true
      slug        = "sqlmi"
      min_length  = 1
      max_length  = 63
      scope       = "global"
      regex       = "^[a-z0-9][a-z0-9-]+[a-z0-9]$"
      description = "Mssql Managed Instance"
    } : null
    mssql_server = var.enabled_all || lookup(var.enabled, "mssql_server", false) ? {
      name        = substr(join("-", compact([local.prefix, "sql", local.suffix])), 0, 63)
      name_unique = substr(join("-", compact([local.prefix, "sql", local.suffix_unique])), 0, 63)
      dashes      = true
      slug        = "sql"
      min_length  = 1
      max_length  = 63
      scope       = "global"
      regex       = "^[a-z0-9][a-z0-9-]+[a-z0-9]$"
      description = "Mssql Server"
    } : null
    mysql_database = var.enabled_all || lookup(var.enabled, "mysql_database", false) ? {
      name        = substr(join("-", compact([local.prefix, "mysqldb", local.suffix])), 0, 63)
      name_unique = substr(join("-", compact([local.prefix, "mysqldb", local.suffix_unique])), 0, 63)
      dashes      = true
      slug        = "mysqldb"
      min_length  = 1
      max_length  = 63
      scope       = "parent"
      regex       = "^[a-zA-Z0-9-_]+$"
      description = "Mysql Database"
    } : null
    mysql_firewall_rule = var.enabled_all || lookup(var.enabled, "mysql_firewall_rule", false) ? {
      name        = substr(join("-", compact([local.prefix, "mysqlfw", local.suffix])), 0, 128)
      name_unique = substr(join("-", compact([local.prefix, "mysqlfw", local.suffix_unique])), 0, 128)
      dashes      = true
      slug        = "mysqlfw"
      min_length  = 1
      max_length  = 128
      scope       = "parent"
      regex       = "^[a-zA-Z0-9-_]+$"
      description = "Mysql Firewall Rule"
    } : null
    mysql_server = var.enabled_all || lookup(var.enabled, "mysql_server", false) ? {
      name        = substr(join("-", compact([local.prefix, "mysql", local.suffix])), 0, 63)
      name_unique = substr(join("-", compact([local.prefix, "mysql", local.suffix_unique])), 0, 63)
      dashes      = true
      slug        = "mysql"
      min_length  = 3
      max_length  = 63
      scope       = "global"
      regex       = "^[a-z0-9][a-zA-Z0-9-]+[a-z0-9]$"
      description = "Mysql Server"
    } : null
    mysql_virtual_network_rule = var.enabled_all || lookup(var.enabled, "mysql_virtual_network_rule", false) ? {
      name        = substr(join("-", compact([local.prefix, "mysqlvn", local.suffix])), 0, 128)
      name_unique = substr(join("-", compact([local.prefix, "mysqlvn", local.suffix_unique])), 0, 128)
      dashes      = true
      slug        = "mysqlvn"
      min_length  = 1
      max_length  = 128
      scope       = "parent"
      regex       = "^[a-zA-Z0-9-_]+$"
      description = "Mysql Virtual Network Rule"
    } : null
    nat_gateway = var.enabled_all || lookup(var.enabled, "nat_gateway", false) ? {
      name        = substr(join("-", compact([local.prefix, "ng", local.suffix])), 0, 80)
      name_unique = substr(join("-", compact([local.prefix, "ng", local.suffix_unique])), 0, 80)
      dashes      = true
      slug        = "ng"
      min_length  = 1
      max_length  = 80
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9_]$"
      description = "Nat Gateway"
    } : null
    network_ddos_protection_plan = var.enabled_all || lookup(var.enabled, "network_ddos_protection_plan", false) ? {
      name        = substr(join("-", compact([local.prefix, "ddospp", local.suffix])), 0, 80)
      name_unique = substr(join("-", compact([local.prefix, "ddospp", local.suffix_unique])), 0, 80)
      dashes      = true
      slug        = "ddospp"
      min_length  = 1
      max_length  = 80
      scope       = "parent"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9_]$"
      description = "Network Ddos Protection Plan"
    } : null
    network_interface = var.enabled_all || lookup(var.enabled, "network_interface", false) ? {
      name        = substr(join("-", compact([local.prefix, "nic", local.suffix])), 0, 80)
      name_unique = substr(join("-", compact([local.prefix, "nic", local.suffix_unique])), 0, 80)
      dashes      = true
      slug        = "nic"
      min_length  = 1
      max_length  = 80
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9_]$"
      description = "Network Interface"
    } : null
    network_security_group = var.enabled_all || lookup(var.enabled, "network_security_group", false) ? {
      name        = substr(join("-", compact([local.prefix, "nsg", local.suffix])), 0, 80)
      name_unique = substr(join("-", compact([local.prefix, "nsg", local.suffix_unique])), 0, 80)
      dashes      = true
      slug        = "nsg"
      min_length  = 1
      max_length  = 80
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9_]$"
      description = "Network Security Group"
    } : null
    network_security_group_rule = var.enabled_all || lookup(var.enabled, "network_security_group_rule", false) ? {
      name        = substr(join("-", compact([local.prefix, "nsgr", local.suffix])), 0, 80)
      name_unique = substr(join("-", compact([local.prefix, "nsgr", local.suffix_unique])), 0, 80)
      dashes      = true
      slug        = "nsgr"
      min_length  = 1
      max_length  = 80
      scope       = "parent"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9_]$"
      description = "Network Security Group Rule"
    } : null
    network_security_rule = var.enabled_all || lookup(var.enabled, "network_security_rule", false) ? {
      name        = substr(join("-", compact([local.prefix, "nsgr", local.suffix])), 0, 80)
      name_unique = substr(join("-", compact([local.prefix, "nsgr", local.suffix_unique])), 0, 80)
      dashes      = true
      slug        = "nsgr"
      min_length  = 1
      max_length  = 80
      scope       = "parent"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9_]$"
      description = "Network Security Rule"
    } : null
    network_watcher = var.enabled_all || lookup(var.enabled, "network_watcher", false) ? {
      name        = substr(join("-", compact([local.prefix, "nw", local.suffix])), 0, 80)
      name_unique = substr(join("-", compact([local.prefix, "nw", local.suffix_unique])), 0, 80)
      dashes      = true
      slug        = "nw"
      min_length  = 1
      max_length  = 80
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9_]$"
      description = "Network Watcher"
    } : null
    notification_hub = var.enabled_all || lookup(var.enabled, "notification_hub", false) ? {
      name        = substr(join("-", compact([local.prefix, "nh", local.suffix])), 0, 260)
      name_unique = substr(join("-", compact([local.prefix, "nh", local.suffix_unique])), 0, 260)
      dashes      = true
      slug        = "nh"
      min_length  = 1
      max_length  = 260
      scope       = "parent"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+$"
      description = "Notification Hub"
    } : null
    notification_hub_authorization_rule = var.enabled_all || lookup(var.enabled, "notification_hub_authorization_rule", false) ? {
      name        = substr(join("-", compact([local.prefix, "dnsrec", local.suffix])), 0, 256)
      name_unique = substr(join("-", compact([local.prefix, "dnsrec", local.suffix_unique])), 0, 256)
      dashes      = true
      slug        = "dnsrec"
      min_length  = 1
      max_length  = 256
      scope       = "parent"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+$"
      description = "Notification Hub Authorization Rule"
    } : null
    notification_hub_namespace = var.enabled_all || lookup(var.enabled, "notification_hub_namespace", false) ? {
      name        = substr(join("-", compact([local.prefix, "dnsrec", local.suffix])), 0, 50)
      name_unique = substr(join("-", compact([local.prefix, "dnsrec", local.suffix_unique])), 0, 50)
      dashes      = true
      slug        = "dnsrec"
      min_length  = 6
      max_length  = 50
      scope       = "global"
      regex       = "^[a-zA-Z][a-zA-Z0-9-]+[a-zA-Z0-9]$"
      description = "Notification Hub Namespace"
    } : null
    point_to_site_vpn_gateway = var.enabled_all || lookup(var.enabled, "point_to_site_vpn_gateway", false) ? {
      name        = substr(join("-", compact([local.prefix, "vpngw", local.suffix])), 0, 80)
      name_unique = substr(join("-", compact([local.prefix, "vpngw", local.suffix_unique])), 0, 80)
      dashes      = true
      slug        = "vpngw"
      min_length  = 1
      max_length  = 80
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9_]$"
      description = "Point To Site Vpn Gateway"
    } : null
    postgresql_database = var.enabled_all || lookup(var.enabled, "postgresql_database", false) ? {
      name        = substr(join("-", compact([local.prefix, "psqldb", local.suffix])), 0, 63)
      name_unique = substr(join("-", compact([local.prefix, "psqldb", local.suffix_unique])), 0, 63)
      dashes      = true
      slug        = "psqldb"
      min_length  = 1
      max_length  = 63
      scope       = "parent"
      regex       = "^[a-zA-Z0-9-_]+$"
      description = "Postgresql Database"
    } : null
    postgresql_firewall_rule = var.enabled_all || lookup(var.enabled, "postgresql_firewall_rule", false) ? {
      name        = substr(join("-", compact([local.prefix, "psqlfw", local.suffix])), 0, 128)
      name_unique = substr(join("-", compact([local.prefix, "psqlfw", local.suffix_unique])), 0, 128)
      dashes      = true
      slug        = "psqlfw"
      min_length  = 1
      max_length  = 128
      scope       = "parent"
      regex       = "^[a-zA-Z0-9-_]+$"
      description = "Postgresql Firewall Rule"
    } : null
    postgresql_flexible_server = var.enabled_all || lookup(var.enabled, "postgresql_flexible_server", false) ? {
      name        = substr(join("-", compact([local.prefix, "psqlf", local.suffix])), 0, 63)
      name_unique = substr(join("-", compact([local.prefix, "psqlf", local.suffix_unique])), 0, 63)
      dashes      = true
      slug        = "psqlf"
      min_length  = 3
      max_length  = 63
      scope       = "global"
      regex       = "^[a-z0-9][a-zA-Z0-9-]+[a-z0-9]$"
      description = "Postgresql Flexible Server"
    } : null
    postgresql_flexible_server_firewall_rule = var.enabled_all || lookup(var.enabled, "postgresql_flexible_server_firewall_rule", false) ? {
      name        = substr(join("-", compact([local.prefix, "psqlffw", local.suffix])), 0, 80)
      name_unique = substr(join("-", compact([local.prefix, "psqlffw", local.suffix_unique])), 0, 80)
      dashes      = true
      slug        = "psqlffw"
      min_length  = 1
      max_length  = 80
      scope       = "global"
      regex       = "^[a-zA-Z0-9-_]+$"
      description = "Postgresql Flexible Server Firewall Rule"
    } : null
    postgresql_server = var.enabled_all || lookup(var.enabled, "postgresql_server", false) ? {
      name        = substr(join("-", compact([local.prefix, "psql", local.suffix])), 0, 63)
      name_unique = substr(join("-", compact([local.prefix, "psql", local.suffix_unique])), 0, 63)
      dashes      = true
      slug        = "psql"
      min_length  = 3
      max_length  = 63
      scope       = "global"
      regex       = "^[a-z0-9][a-zA-Z0-9-]+[a-z0-9]$"
      description = "Postgresql Server"
    } : null
    postgresql_virtual_network_rule = var.enabled_all || lookup(var.enabled, "postgresql_virtual_network_rule", false) ? {
      name        = substr(join("-", compact([local.prefix, "psqlvn", local.suffix])), 0, 128)
      name_unique = substr(join("-", compact([local.prefix, "psqlvn", local.suffix_unique])), 0, 128)
      dashes      = true
      slug        = "psqlvn"
      min_length  = 1
      max_length  = 128
      scope       = "parent"
      regex       = "^[a-zA-Z0-9-_]+$"
      description = "Postgresql Virtual Network Rule"
    } : null
    powerbi_embedded = var.enabled_all || lookup(var.enabled, "powerbi_embedded", false) ? {
      name        = substr(join("-", compact([local.prefix, "pbi", local.suffix])), 0, 63)
      name_unique = substr(join("-", compact([local.prefix, "pbi", local.suffix_unique])), 0, 63)
      dashes      = true
      slug        = "pbi"
      min_length  = 3
      max_length  = 63
      scope       = "region"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-]+$"
      description = "Powerbi Embedded"
    } : null
    private_dns_a_record = var.enabled_all || lookup(var.enabled, "private_dns_a_record", false) ? {
      name        = substr(join("-", compact([local.prefix, "pdnsrec", local.suffix])), 0, 80)
      name_unique = substr(join("-", compact([local.prefix, "pdnsrec", local.suffix_unique])), 0, 80)
      dashes      = true
      slug        = "pdnsrec"
      min_length  = 1
      max_length  = 80
      scope       = "parent"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9_]$"
      description = "Private Dns A Record"
    } : null
    private_dns_aaaa_record = var.enabled_all || lookup(var.enabled, "private_dns_aaaa_record", false) ? {
      name        = substr(join("-", compact([local.prefix, "pdnsrec", local.suffix])), 0, 80)
      name_unique = substr(join("-", compact([local.prefix, "pdnsrec", local.suffix_unique])), 0, 80)
      dashes      = true
      slug        = "pdnsrec"
      min_length  = 1
      max_length  = 80
      scope       = "parent"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9_]$"
      description = "Private Dns Aaaa Record"
    } : null
    private_dns_cname_record = var.enabled_all || lookup(var.enabled, "private_dns_cname_record", false) ? {
      name        = substr(join("-", compact([local.prefix, "pdnsrec", local.suffix])), 0, 80)
      name_unique = substr(join("-", compact([local.prefix, "pdnsrec", local.suffix_unique])), 0, 80)
      dashes      = true
      slug        = "pdnsrec"
      min_length  = 1
      max_length  = 80
      scope       = "parent"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9_]$"
      description = "Private Dns Cname Record"
    } : null
    private_dns_mx_record = var.enabled_all || lookup(var.enabled, "private_dns_mx_record", false) ? {
      name        = substr(join("-", compact([local.prefix, "pdnsrec", local.suffix])), 0, 80)
      name_unique = substr(join("-", compact([local.prefix, "pdnsrec", local.suffix_unique])), 0, 80)
      dashes      = true
      slug        = "pdnsrec"
      min_length  = 1
      max_length  = 80
      scope       = "parent"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9_]$"
      description = "Private Dns Mx Record"
    } : null
    private_dns_ptr_record = var.enabled_all || lookup(var.enabled, "private_dns_ptr_record", false) ? {
      name        = substr(join("-", compact([local.prefix, "pdnsrec", local.suffix])), 0, 80)
      name_unique = substr(join("-", compact([local.prefix, "pdnsrec", local.suffix_unique])), 0, 80)
      dashes      = true
      slug        = "pdnsrec"
      min_length  = 1
      max_length  = 80
      scope       = "parent"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9_]$"
      description = "Private Dns Ptr Record"
    } : null
    private_dns_srv_record = var.enabled_all || lookup(var.enabled, "private_dns_srv_record", false) ? {
      name        = substr(join("-", compact([local.prefix, "pdnsrec", local.suffix])), 0, 80)
      name_unique = substr(join("-", compact([local.prefix, "pdnsrec", local.suffix_unique])), 0, 80)
      dashes      = true
      slug        = "pdnsrec"
      min_length  = 1
      max_length  = 80
      scope       = "parent"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9_]$"
      description = "Private Dns Srv Record"
    } : null
    private_dns_txt_record = var.enabled_all || lookup(var.enabled, "private_dns_txt_record", false) ? {
      name        = substr(join("-", compact([local.prefix, "pdnsrec", local.suffix])), 0, 80)
      name_unique = substr(join("-", compact([local.prefix, "pdnsrec", local.suffix_unique])), 0, 80)
      dashes      = true
      slug        = "pdnsrec"
      min_length  = 1
      max_length  = 80
      scope       = "parent"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9_]$"
      description = "Private Dns Txt Record"
    } : null
    private_dns_zone = var.enabled_all || lookup(var.enabled, "private_dns_zone", false) ? {
      name        = substr(join("-", compact([local.prefix, "pdns", local.suffix])), 0, 63)
      name_unique = substr(join("-", compact([local.prefix, "pdns", local.suffix_unique])), 0, 63)
      dashes      = true
      slug        = "pdns"
      min_length  = 1
      max_length  = 63
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9_]$"
      description = "Private Dns Zone"
    } : null
    private_dns_zone_group = var.enabled_all || lookup(var.enabled, "private_dns_zone_group", false) ? {
      name        = substr(join("-", compact([local.prefix, "pdnszg", local.suffix])), 0, 80)
      name_unique = substr(join("-", compact([local.prefix, "pdnszg", local.suffix_unique])), 0, 80)
      dashes      = true
      slug        = "pdnszg"
      min_length  = 1
      max_length  = 80
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9\\-\\._]+[a-zA-Z0-9_]$"
      description = "Private Dns Zone Group"
    } : null
    private_endpoint = var.enabled_all || lookup(var.enabled, "private_endpoint", false) ? {
      name        = substr(join("-", compact([local.prefix, "pe", local.suffix])), 0, 80)
      name_unique = substr(join("-", compact([local.prefix, "pe", local.suffix_unique])), 0, 80)
      dashes      = true
      slug        = "pe"
      min_length  = 1
      max_length  = 80
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9\\-\\._]+[a-zA-Z0-9_]$"
      description = "Private Endpoint"
    } : null
    private_link_service = var.enabled_all || lookup(var.enabled, "private_link_service", false) ? {
      name        = substr(join("-", compact([local.prefix, "pls", local.suffix])), 0, 80)
      name_unique = substr(join("-", compact([local.prefix, "pls", local.suffix_unique])), 0, 80)
      dashes      = true
      slug        = "pls"
      min_length  = 1
      max_length  = 80
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9_]$"
      description = "Private Link Service"
    } : null
    private_service_connection = var.enabled_all || lookup(var.enabled, "private_service_connection", false) ? {
      name        = substr(join("-", compact([local.prefix, "psc", local.suffix])), 0, 80)
      name_unique = substr(join("-", compact([local.prefix, "psc", local.suffix_unique])), 0, 80)
      dashes      = true
      slug        = "psc"
      min_length  = 1
      max_length  = 80
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9\\-\\._]+[a-zA-Z0-9_]$"
      description = "Private Service Connection"
    } : null
    proximity_placement_group = var.enabled_all || lookup(var.enabled, "proximity_placement_group", false) ? {
      name        = substr(join("-", compact([local.prefix, "ppg", local.suffix])), 0, 80)
      name_unique = substr(join("-", compact([local.prefix, "ppg", local.suffix_unique])), 0, 80)
      dashes      = true
      slug        = "ppg"
      min_length  = 1
      max_length  = 80
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9_]$"
      description = "Proximity Placement Group"
    } : null
    public_ip = var.enabled_all || lookup(var.enabled, "public_ip", false) ? {
      name        = substr(join("-", compact([local.prefix, "pip", local.suffix])), 0, 80)
      name_unique = substr(join("-", compact([local.prefix, "pip", local.suffix_unique])), 0, 80)
      dashes      = true
      slug        = "pip"
      min_length  = 1
      max_length  = 80
      scope       = "parent"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9_]$"
      description = "Public Ip"
    } : null
    public_ip_prefix = var.enabled_all || lookup(var.enabled, "public_ip_prefix", false) ? {
      name        = substr(join("-", compact([local.prefix, "pippf", local.suffix])), 0, 80)
      name_unique = substr(join("-", compact([local.prefix, "pippf", local.suffix_unique])), 0, 80)
      dashes      = true
      slug        = "pippf"
      min_length  = 1
      max_length  = 80
      scope       = "parent"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9_]$"
      description = "Public Ip Prefix"
    } : null
    recovery_services_vault = var.enabled_all || lookup(var.enabled, "recovery_services_vault", false) ? {
      name        = substr(join("-", compact([local.prefix, "rsv", local.suffix])), 0, 50)
      name_unique = substr(join("-", compact([local.prefix, "rsv", local.suffix_unique])), 0, 50)
      dashes      = true
      slug        = "rsv"
      min_length  = 2
      max_length  = 50
      scope       = "global"
      regex       = "^[a-zA-Z][a-zA-Z0-9-]+[a-zA-Z0-9]$"
      description = "Recovery Services Vault"
    } : null
    redis_cache = var.enabled_all || lookup(var.enabled, "redis_cache", false) ? {
      name        = substr(join("-", compact([local.prefix, "redis", local.suffix])), 0, 63)
      name_unique = substr(join("-", compact([local.prefix, "redis", local.suffix_unique])), 0, 63)
      dashes      = true
      slug        = "redis"
      min_length  = 1
      max_length  = 63
      scope       = "global"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]$"
      description = "Redis Cache"
    } : null
    redis_firewall_rule = var.enabled_all || lookup(var.enabled, "redis_firewall_rule", false) ? {
      name        = substr(join("", compact([local.prefix_safe, "redisfw", local.suffix_safe])), 0, 256)
      name_unique = substr(join("", compact([local.prefix_safe, "redisfw", local.suffix_unique_safe])), 0, 256)
      dashes      = false
      slug        = "redisfw"
      min_length  = 1
      max_length  = 256
      scope       = "parent"
      regex       = "^[a-zA-Z0-9]+$"
      description = "Redis Firewall Rule"
    } : null
    relay_hybrid_connection = var.enabled_all || lookup(var.enabled, "relay_hybrid_connection", false) ? {
      name        = substr(join("-", compact([local.prefix, "rlhc", local.suffix])), 0, 260)
      name_unique = substr(join("-", compact([local.prefix, "rlhc", local.suffix_unique])), 0, 260)
      dashes      = true
      slug        = "rlhc"
      min_length  = 1
      max_length  = 260
      scope       = "parent"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9]$"
      description = "Relay Hybrid Connection"
    } : null
    relay_namespace = var.enabled_all || lookup(var.enabled, "relay_namespace", false) ? {
      name        = substr(join("-", compact([local.prefix, "rln", local.suffix])), 0, 50)
      name_unique = substr(join("-", compact([local.prefix, "rln", local.suffix_unique])), 0, 50)
      dashes      = true
      slug        = "rln"
      min_length  = 6
      max_length  = 50
      scope       = "global"
      regex       = "^[a-zA-Z][a-zA-Z0-9-]+[a-zA-Z0-9]$"
      description = "Relay Namespace"
    } : null
    resource_group = var.enabled_all || lookup(var.enabled, "resource_group", false) ? {
      name        = substr(join("-", compact([local.prefix, "rg", local.suffix])), 0, 90)
      name_unique = substr(join("-", compact([local.prefix, "rg", local.suffix_unique])), 0, 90)
      dashes      = true
      slug        = "rg"
      min_length  = 1
      max_length  = 90
      scope       = "subscription"
      regex       = "^[a-zA-Z0-9-._\\(\\)]+[a-zA-Z0-9-_\\(\\)]$"
      description = "Resource Group"
    } : null
    role_assignment = var.enabled_all || lookup(var.enabled, "role_assignment", false) ? {
      name        = substr(join("-", compact([local.prefix, "ra", local.suffix])), 0, 64)
      name_unique = substr(join("-", compact([local.prefix, "ra", local.suffix_unique])), 0, 64)
      dashes      = true
      slug        = "ra"
      min_length  = 1
      max_length  = 64
      scope       = "assignment"
      regex       = "^[^%]+[^ %.]$"
      description = "Role Assignment"
    } : null
    role_definition = var.enabled_all || lookup(var.enabled, "role_definition", false) ? {
      name        = substr(join("-", compact([local.prefix, "rd", local.suffix])), 0, 64)
      name_unique = substr(join("-", compact([local.prefix, "rd", local.suffix_unique])), 0, 64)
      dashes      = true
      slug        = "rd"
      min_length  = 1
      max_length  = 64
      scope       = "definition"
      regex       = "^[^%]+[^ %.]$"
      description = "Role Definition"
    } : null
    route = var.enabled_all || lookup(var.enabled, "route", false) ? {
      name        = substr(join("-", compact([local.prefix, "rt", local.suffix])), 0, 80)
      name_unique = substr(join("-", compact([local.prefix, "rt", local.suffix_unique])), 0, 80)
      dashes      = true
      slug        = "rt"
      min_length  = 1
      max_length  = 80
      scope       = "parent"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9_]$"
      description = "Route"
    } : null
    route_table = var.enabled_all || lookup(var.enabled, "route_table", false) ? {
      name        = substr(join("-", compact([local.prefix, "route", local.suffix])), 0, 80)
      name_unique = substr(join("-", compact([local.prefix, "route", local.suffix_unique])), 0, 80)
      dashes      = true
      slug        = "route"
      min_length  = 1
      max_length  = 80
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9_]$"
      description = "Route Table"
    } : null
    search_service = var.enabled_all || lookup(var.enabled, "search_service", false) ? {
      name        = substr(join("-", compact([local.prefix, "srch", local.suffix])), 0, 64)
      name_unique = substr(join("-", compact([local.prefix, "srch", local.suffix_unique])), 0, 64)
      dashes      = true
      slug        = "srch"
      min_length  = 2
      max_length  = 64
      scope       = "global"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-]+$"
      description = "Search Service"
    } : null
    service_fabric_cluster = var.enabled_all || lookup(var.enabled, "service_fabric_cluster", false) ? {
      name        = substr(join("-", compact([local.prefix, "sf", local.suffix])), 0, 23)
      name_unique = substr(join("-", compact([local.prefix, "sf", local.suffix_unique])), 0, 23)
      dashes      = true
      slug        = "sf"
      min_length  = 4
      max_length  = 23
      scope       = "region"
      regex       = "^[a-z][a-z0-9-]+[a-z0-9]$"
      description = "Service Fabric Cluster"
    } : null
    servicebus_namespace = var.enabled_all || lookup(var.enabled, "servicebus_namespace", false) ? {
      name        = substr(join("-", compact([local.prefix, "sb", local.suffix])), 0, 50)
      name_unique = substr(join("-", compact([local.prefix, "sb", local.suffix_unique])), 0, 50)
      dashes      = true
      slug        = "sb"
      min_length  = 6
      max_length  = 50
      scope       = "global"
      regex       = "^[a-zA-Z][a-zA-Z0-9-]+[a-zA-Z0-9]$"
      description = "Servicebus Namespace"
    } : null
    servicebus_namespace_authorization_rule = var.enabled_all || lookup(var.enabled, "servicebus_namespace_authorization_rule", false) ? {
      name        = substr(join("-", compact([local.prefix, "sbar", local.suffix])), 0, 50)
      name_unique = substr(join("-", compact([local.prefix, "sbar", local.suffix_unique])), 0, 50)
      dashes      = true
      slug        = "sbar"
      min_length  = 1
      max_length  = 50
      scope       = "parent"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9]$"
      description = "Servicebus Namespace Authorization Rule"
    } : null
    servicebus_queue = var.enabled_all || lookup(var.enabled, "servicebus_queue", false) ? {
      name        = substr(join("-", compact([local.prefix, "sbq", local.suffix])), 0, 260)
      name_unique = substr(join("-", compact([local.prefix, "sbq", local.suffix_unique])), 0, 260)
      dashes      = true
      slug        = "sbq"
      min_length  = 1
      max_length  = 260
      scope       = "parent"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9_]$"
      description = "Servicebus Queue"
    } : null
    servicebus_queue_authorization_rule = var.enabled_all || lookup(var.enabled, "servicebus_queue_authorization_rule", false) ? {
      name        = substr(join("-", compact([local.prefix, "sbqar", local.suffix])), 0, 50)
      name_unique = substr(join("-", compact([local.prefix, "sbqar", local.suffix_unique])), 0, 50)
      dashes      = true
      slug        = "sbqar"
      min_length  = 1
      max_length  = 50
      scope       = "parent"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9]$"
      description = "Servicebus Queue Authorization Rule"
    } : null
    servicebus_subscription = var.enabled_all || lookup(var.enabled, "servicebus_subscription", false) ? {
      name        = substr(join("-", compact([local.prefix, "sbs", local.suffix])), 0, 50)
      name_unique = substr(join("-", compact([local.prefix, "sbs", local.suffix_unique])), 0, 50)
      dashes      = true
      slug        = "sbs"
      min_length  = 1
      max_length  = 50
      scope       = "parent"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9]$"
      description = "Servicebus Subscription"
    } : null
    servicebus_subscription_rule = var.enabled_all || lookup(var.enabled, "servicebus_subscription_rule", false) ? {
      name        = substr(join("-", compact([local.prefix, "sbsr", local.suffix])), 0, 50)
      name_unique = substr(join("-", compact([local.prefix, "sbsr", local.suffix_unique])), 0, 50)
      dashes      = true
      slug        = "sbsr"
      min_length  = 1
      max_length  = 50
      scope       = "parent"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9]$"
      description = "Servicebus Subscription Rule"
    } : null
    servicebus_topic = var.enabled_all || lookup(var.enabled, "servicebus_topic", false) ? {
      name        = substr(join("-", compact([local.prefix, "sbt", local.suffix])), 0, 260)
      name_unique = substr(join("-", compact([local.prefix, "sbt", local.suffix_unique])), 0, 260)
      dashes      = true
      slug        = "sbt"
      min_length  = 1
      max_length  = 260
      scope       = "parent"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9]$"
      description = "Servicebus Topic"
    } : null
    servicebus_topic_authorization_rule = var.enabled_all || lookup(var.enabled, "servicebus_topic_authorization_rule", false) ? {
      name        = substr(join("-", compact([local.prefix, "dnsrec", local.suffix])), 0, 50)
      name_unique = substr(join("-", compact([local.prefix, "dnsrec", local.suffix_unique])), 0, 50)
      dashes      = true
      slug        = "dnsrec"
      min_length  = 1
      max_length  = 50
      scope       = "parent"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9]$"
      description = "Servicebus Topic Authorization Rule"
    } : null
    shared_image = var.enabled_all || lookup(var.enabled, "shared_image", false) ? {
      name        = substr(join("-", compact([local.prefix, "si", local.suffix])), 0, 80)
      name_unique = substr(join("-", compact([local.prefix, "si", local.suffix_unique])), 0, 80)
      dashes      = true
      slug        = "si"
      min_length  = 1
      max_length  = 80
      scope       = "parent"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9]$"
      description = "Shared Image"
    } : null
    shared_image_gallery = var.enabled_all || lookup(var.enabled, "shared_image_gallery", false) ? {
      name        = substr(join("", compact([local.prefix_safe, "sig", local.suffix_safe])), 0, 80)
      name_unique = substr(join("", compact([local.prefix_safe, "sig", local.suffix_unique_safe])), 0, 80)
      dashes      = false
      slug        = "sig"
      min_length  = 1
      max_length  = 80
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9.]+[a-zA-Z0-9]$"
      description = "Shared Image Gallery"
    } : null
    signalr_service = var.enabled_all || lookup(var.enabled, "signalr_service", false) ? {
      name        = substr(join("-", compact([local.prefix, "sgnlr", local.suffix])), 0, 63)
      name_unique = substr(join("-", compact([local.prefix, "sgnlr", local.suffix_unique])), 0, 63)
      dashes      = true
      slug        = "sgnlr"
      min_length  = 3
      max_length  = 63
      scope       = "global"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]$"
      description = "Signalr Service"
    } : null
    snapshots = var.enabled_all || lookup(var.enabled, "snapshots", false) ? {
      name        = substr(join("-", compact([local.prefix, "snap", local.suffix])), 0, 80)
      name_unique = substr(join("-", compact([local.prefix, "snap", local.suffix_unique])), 0, 80)
      dashes      = true
      slug        = "snap"
      min_length  = 1
      max_length  = 80
      scope       = "parent"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9_]$"
      description = "Snapshots"
    } : null
    sql_elasticpool = var.enabled_all || lookup(var.enabled, "sql_elasticpool", false) ? {
      name        = substr(join("-", compact([local.prefix, "sqlep", local.suffix])), 0, 128)
      name_unique = substr(join("-", compact([local.prefix, "sqlep", local.suffix_unique])), 0, 128)
      dashes      = true
      slug        = "sqlep"
      min_length  = 1
      max_length  = 128
      scope       = "parent"
      regex       = "^[^<>*%:.?\\+\\/]+[^<>*%:.?\\+\\/ ]$"
      description = "Sql Elasticpool"
    } : null
    sql_failover_group = var.enabled_all || lookup(var.enabled, "sql_failover_group", false) ? {
      name        = substr(join("-", compact([local.prefix, "sqlfg", local.suffix])), 0, 63)
      name_unique = substr(join("-", compact([local.prefix, "sqlfg", local.suffix_unique])), 0, 63)
      dashes      = true
      slug        = "sqlfg"
      min_length  = 1
      max_length  = 63
      scope       = "global"
      regex       = "^[a-z0-9][a-z0-9-]+[a-z0-9]$"
      description = "Sql Failover Group"
    } : null
    sql_firewall_rule = var.enabled_all || lookup(var.enabled, "sql_firewall_rule", false) ? {
      name        = substr(join("-", compact([local.prefix, "sqlfw", local.suffix])), 0, 128)
      name_unique = substr(join("-", compact([local.prefix, "sqlfw", local.suffix_unique])), 0, 128)
      dashes      = true
      slug        = "sqlfw"
      min_length  = 1
      max_length  = 128
      scope       = "parent"
      regex       = "^[^<>*%:?\\+\\/]+[^<>*%:.?\\+\\/]$"
      description = "Sql Firewall Rule"
    } : null
    sql_server = var.enabled_all || lookup(var.enabled, "sql_server", false) ? {
      name        = substr(join("-", compact([local.prefix, "sql", local.suffix])), 0, 63)
      name_unique = substr(join("-", compact([local.prefix, "sql", local.suffix_unique])), 0, 63)
      dashes      = true
      slug        = "sql"
      min_length  = 1
      max_length  = 63
      scope       = "global"
      regex       = "^[a-z0-9][a-z0-9-]+[a-z0-9]$"
      description = "Sql Server"
    } : null
    static_web_app = var.enabled_all || lookup(var.enabled, "static_web_app", false) ? {
      name        = substr(join("-", compact([local.prefix, "stapp", local.suffix])), 0, 40)
      name_unique = substr(join("-", compact([local.prefix, "stapp", local.suffix_unique])), 0, 40)
      dashes      = true
      slug        = "stapp"
      min_length  = 1
      max_length  = 40
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]$"
      description = "Static Web App"
    } : null
    storage_account = var.enabled_all || lookup(var.enabled, "storage_account", false) ? {
      name        = substr(join("", compact([local.prefix_safe, "st", local.suffix_safe])), 0, 24)
      name_unique = substr(join("", compact([local.prefix_safe, "st", local.suffix_unique_safe])), 0, 24)
      dashes      = false
      slug        = "st"
      min_length  = 3
      max_length  = 24
      scope       = "global"
      regex       = "^[a-z0-9]+$"
      description = "Storage Account"
    } : null
    storage_blob = var.enabled_all || lookup(var.enabled, "storage_blob", false) ? {
      name        = substr(join("-", compact([local.prefix, "blob", local.suffix])), 0, 1024)
      name_unique = substr(join("-", compact([local.prefix, "blob", local.suffix_unique])), 0, 1024)
      dashes      = true
      slug        = "blob"
      min_length  = 1
      max_length  = 1024
      scope       = "parent"
      regex       = "^[^\\s\\/$#&]+$"
      description = "Storage Blob"
    } : null
    storage_container = var.enabled_all || lookup(var.enabled, "storage_container", false) ? {
      name        = substr(join("-", compact([local.prefix, "stct", local.suffix])), 0, 63)
      name_unique = substr(join("-", compact([local.prefix, "stct", local.suffix_unique])), 0, 63)
      dashes      = true
      slug        = "stct"
      min_length  = 3
      max_length  = 63
      scope       = "parent"
      regex       = "^[a-z0-9][a-z0-9-]+$"
      description = "Storage Container"
    } : null
    storage_data_lake_gen2_filesystem = var.enabled_all || lookup(var.enabled, "storage_data_lake_gen2_filesystem", false) ? {
      name        = substr(join("-", compact([local.prefix, "stdl", local.suffix])), 0, 63)
      name_unique = substr(join("-", compact([local.prefix, "stdl", local.suffix_unique])), 0, 63)
      dashes      = true
      slug        = "stdl"
      min_length  = 3
      max_length  = 63
      scope       = "parent"
      regex       = "^[a-z0-9][a-z0-9-]+[a-z0-9]$"
      description = "Storage Data Lake Gen2 Filesystem"
    } : null
    storage_queue = var.enabled_all || lookup(var.enabled, "storage_queue", false) ? {
      name        = substr(join("-", compact([local.prefix, "stq", local.suffix])), 0, 63)
      name_unique = substr(join("-", compact([local.prefix, "stq", local.suffix_unique])), 0, 63)
      dashes      = true
      slug        = "stq"
      min_length  = 3
      max_length  = 63
      scope       = "parent"
      regex       = "^[a-z0-9][a-z0-9-]+[a-z0-9]$"
      description = "Storage Queue"
    } : null
    storage_share = var.enabled_all || lookup(var.enabled, "storage_share", false) ? {
      name        = substr(join("-", compact([local.prefix, "sts", local.suffix])), 0, 63)
      name_unique = substr(join("-", compact([local.prefix, "sts", local.suffix_unique])), 0, 63)
      dashes      = true
      slug        = "sts"
      min_length  = 3
      max_length  = 63
      scope       = "parent"
      regex       = "^[a-z0-9][a-z0-9-]+[a-z0-9]$"
      description = "Storage Share"
    } : null
    storage_share_directory = var.enabled_all || lookup(var.enabled, "storage_share_directory", false) ? {
      name        = substr(join("-", compact([local.prefix, "sts", local.suffix])), 0, 63)
      name_unique = substr(join("-", compact([local.prefix, "sts", local.suffix_unique])), 0, 63)
      dashes      = true
      slug        = "sts"
      min_length  = 3
      max_length  = 63
      scope       = "parent"
      regex       = "^[a-z0-9][a-z0-9-]+[a-z0-9]$"
      description = "Storage Share Directory"
    } : null
    storage_table = var.enabled_all || lookup(var.enabled, "storage_table", false) ? {
      name        = substr(join("-", compact([local.prefix, "stt", local.suffix])), 0, 63)
      name_unique = substr(join("-", compact([local.prefix, "stt", local.suffix_unique])), 0, 63)
      dashes      = true
      slug        = "stt"
      min_length  = 3
      max_length  = 63
      scope       = "parent"
      regex       = "^[a-z0-9][a-z0-9-]+[a-z0-9]$"
      description = "Storage Table"
    } : null
    stream_analytics_function_javascript_udf = var.enabled_all || lookup(var.enabled, "stream_analytics_function_javascript_udf", false) ? {
      name        = substr(join("-", compact([local.prefix, "asafunc", local.suffix])), 0, 63)
      name_unique = substr(join("-", compact([local.prefix, "asafunc", local.suffix_unique])), 0, 63)
      dashes      = true
      slug        = "asafunc"
      min_length  = 3
      max_length  = 63
      scope       = "parent"
      regex       = "^[a-zA-Z0-9-_]+$"
      description = "Stream Analytics Function Javascript Udf"
    } : null
    stream_analytics_job = var.enabled_all || lookup(var.enabled, "stream_analytics_job", false) ? {
      name        = substr(join("-", compact([local.prefix, "asa", local.suffix])), 0, 63)
      name_unique = substr(join("-", compact([local.prefix, "asa", local.suffix_unique])), 0, 63)
      dashes      = true
      slug        = "asa"
      min_length  = 3
      max_length  = 63
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9-_]+$"
      description = "Stream Analytics Job"
    } : null
    stream_analytics_output_blob = var.enabled_all || lookup(var.enabled, "stream_analytics_output_blob", false) ? {
      name        = substr(join("-", compact([local.prefix, "asaoblob", local.suffix])), 0, 63)
      name_unique = substr(join("-", compact([local.prefix, "asaoblob", local.suffix_unique])), 0, 63)
      dashes      = true
      slug        = "asaoblob"
      min_length  = 3
      max_length  = 63
      scope       = "parent"
      regex       = "^[a-zA-Z0-9-_]+$"
      description = "Stream Analytics Output Blob"
    } : null
    stream_analytics_output_eventhub = var.enabled_all || lookup(var.enabled, "stream_analytics_output_eventhub", false) ? {
      name        = substr(join("-", compact([local.prefix, "asaoeh", local.suffix])), 0, 63)
      name_unique = substr(join("-", compact([local.prefix, "asaoeh", local.suffix_unique])), 0, 63)
      dashes      = true
      slug        = "asaoeh"
      min_length  = 3
      max_length  = 63
      scope       = "parent"
      regex       = "^[a-zA-Z0-9-_]+$"
      description = "Stream Analytics Output Eventhub"
    } : null
    stream_analytics_output_mssql = var.enabled_all || lookup(var.enabled, "stream_analytics_output_mssql", false) ? {
      name        = substr(join("-", compact([local.prefix, "asaomssql", local.suffix])), 0, 63)
      name_unique = substr(join("-", compact([local.prefix, "asaomssql", local.suffix_unique])), 0, 63)
      dashes      = true
      slug        = "asaomssql"
      min_length  = 3
      max_length  = 63
      scope       = "parent"
      regex       = "^[a-zA-Z0-9-_]+$"
      description = "Stream Analytics Output Mssql"
    } : null
    stream_analytics_output_servicebus_queue = var.enabled_all || lookup(var.enabled, "stream_analytics_output_servicebus_queue", false) ? {
      name        = substr(join("-", compact([local.prefix, "asaosbq", local.suffix])), 0, 63)
      name_unique = substr(join("-", compact([local.prefix, "asaosbq", local.suffix_unique])), 0, 63)
      dashes      = true
      slug        = "asaosbq"
      min_length  = 3
      max_length  = 63
      scope       = "parent"
      regex       = "^[a-zA-Z0-9-_]+$"
      description = "Stream Analytics Output Servicebus Queue"
    } : null
    stream_analytics_output_servicebus_topic = var.enabled_all || lookup(var.enabled, "stream_analytics_output_servicebus_topic", false) ? {
      name        = substr(join("-", compact([local.prefix, "asaosbt", local.suffix])), 0, 63)
      name_unique = substr(join("-", compact([local.prefix, "asaosbt", local.suffix_unique])), 0, 63)
      dashes      = true
      slug        = "asaosbt"
      min_length  = 3
      max_length  = 63
      scope       = "parent"
      regex       = "^[a-zA-Z0-9-_]+$"
      description = "Stream Analytics Output Servicebus Topic"
    } : null
    stream_analytics_reference_input_blob = var.enabled_all || lookup(var.enabled, "stream_analytics_reference_input_blob", false) ? {
      name        = substr(join("-", compact([local.prefix, "asarblob", local.suffix])), 0, 63)
      name_unique = substr(join("-", compact([local.prefix, "asarblob", local.suffix_unique])), 0, 63)
      dashes      = true
      slug        = "asarblob"
      min_length  = 3
      max_length  = 63
      scope       = "parent"
      regex       = "^[a-zA-Z0-9-_]+$"
      description = "Stream Analytics Reference Input Blob"
    } : null
    stream_analytics_stream_input_blob = var.enabled_all || lookup(var.enabled, "stream_analytics_stream_input_blob", false) ? {
      name        = substr(join("-", compact([local.prefix, "asaiblob", local.suffix])), 0, 63)
      name_unique = substr(join("-", compact([local.prefix, "asaiblob", local.suffix_unique])), 0, 63)
      dashes      = true
      slug        = "asaiblob"
      min_length  = 3
      max_length  = 63
      scope       = "parent"
      regex       = "^[a-zA-Z0-9-_]+$"
      description = "Stream Analytics Stream Input Blob"
    } : null
    stream_analytics_stream_input_eventhub = var.enabled_all || lookup(var.enabled, "stream_analytics_stream_input_eventhub", false) ? {
      name        = substr(join("-", compact([local.prefix, "asaieh", local.suffix])), 0, 63)
      name_unique = substr(join("-", compact([local.prefix, "asaieh", local.suffix_unique])), 0, 63)
      dashes      = true
      slug        = "asaieh"
      min_length  = 3
      max_length  = 63
      scope       = "parent"
      regex       = "^[a-zA-Z0-9-_]+$"
      description = "Stream Analytics Stream Input Eventhub"
    } : null
    stream_analytics_stream_input_iothub = var.enabled_all || lookup(var.enabled, "stream_analytics_stream_input_iothub", false) ? {
      name        = substr(join("-", compact([local.prefix, "asaiiot", local.suffix])), 0, 63)
      name_unique = substr(join("-", compact([local.prefix, "asaiiot", local.suffix_unique])), 0, 63)
      dashes      = true
      slug        = "asaiiot"
      min_length  = 3
      max_length  = 63
      scope       = "parent"
      regex       = "^[a-zA-Z0-9-_]+$"
      description = "Stream Analytics Stream Input Iothub"
    } : null
    subnet = var.enabled_all || lookup(var.enabled, "subnet", false) ? {
      name        = substr(join("-", compact([local.prefix, "snet", local.suffix])), 0, 80)
      name_unique = substr(join("-", compact([local.prefix, "snet", local.suffix_unique])), 0, 80)
      dashes      = true
      slug        = "snet"
      min_length  = 1
      max_length  = 80
      scope       = "parent"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9_]$"
      description = "Subnet"
    } : null
    template_deployment = var.enabled_all || lookup(var.enabled, "template_deployment", false) ? {
      name        = substr(join("-", compact([local.prefix, "deploy", local.suffix])), 0, 64)
      name_unique = substr(join("-", compact([local.prefix, "deploy", local.suffix_unique])), 0, 64)
      dashes      = true
      slug        = "deploy"
      min_length  = 1
      max_length  = 64
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9-._\\(\\)]+$"
      description = "Template Deployment"
    } : null
    traffic_manager_profile = var.enabled_all || lookup(var.enabled, "traffic_manager_profile", false) ? {
      name        = substr(join("-", compact([local.prefix, "traf", local.suffix])), 0, 63)
      name_unique = substr(join("-", compact([local.prefix, "traf", local.suffix_unique])), 0, 63)
      dashes      = true
      slug        = "traf"
      min_length  = 1
      max_length  = 63
      scope       = "global"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-.]+[a-zA-Z0-9_]$"
      description = "Traffic Manager Profile"
    } : null
    user_assigned_identity = var.enabled_all || lookup(var.enabled, "user_assigned_identity", false) ? {
      name        = substr(join("-", compact([local.prefix, "uai", local.suffix])), 0, 128)
      name_unique = substr(join("-", compact([local.prefix, "uai", local.suffix_unique])), 0, 128)
      dashes      = true
      slug        = "uai"
      min_length  = 3
      max_length  = 128
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9-_]+$"
      description = "User Assigned Identity"
    } : null
    virtual_desktop_application_group = var.enabled_all || lookup(var.enabled, "virtual_desktop_application_group", false) ? {
      name        = substr(join("-", compact([local.prefix, "vdag", local.suffix])), 0, 63)
      name_unique = substr(join("-", compact([local.prefix, "vdag", local.suffix_unique])), 0, 63)
      dashes      = true
      slug        = "vdag"
      min_length  = 3
      max_length  = 63
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-.]+[a-zA-Z0-9_]$"
      description = "Virtual Desktop Application Group"
    } : null
    virtual_desktop_host_pool = var.enabled_all || lookup(var.enabled, "virtual_desktop_host_pool", false) ? {
      name        = substr(join("-", compact([local.prefix, "vdpool", local.suffix])), 0, 63)
      name_unique = substr(join("-", compact([local.prefix, "vdpool", local.suffix_unique])), 0, 63)
      dashes      = true
      slug        = "vdpool"
      min_length  = 3
      max_length  = 63
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-.]+[a-zA-Z0-9_]$"
      description = "Virtual Desktop Host Pool"
    } : null
    virtual_desktop_scaling_plan = var.enabled_all || lookup(var.enabled, "virtual_desktop_scaling_plan", false) ? {
      name        = substr(join("-", compact([local.prefix, "vdscaling", local.suffix])), 0, 63)
      name_unique = substr(join("-", compact([local.prefix, "vdscaling", local.suffix_unique])), 0, 63)
      dashes      = true
      slug        = "vdscaling"
      min_length  = 3
      max_length  = 63
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-.]+[a-zA-Z0-9_]$"
      description = "Virtual Desktop Scaling Plan"
    } : null
    virtual_desktop_workspace = var.enabled_all || lookup(var.enabled, "virtual_desktop_workspace", false) ? {
      name        = substr(join("-", compact([local.prefix, "vdws", local.suffix])), 0, 63)
      name_unique = substr(join("-", compact([local.prefix, "vdws", local.suffix_unique])), 0, 63)
      dashes      = true
      slug        = "vdws"
      min_length  = 3
      max_length  = 63
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-.]+[a-zA-Z0-9_]$"
      description = "Virtual Desktop Workspace"
    } : null
    virtual_machine = var.enabled_all || lookup(var.enabled, "virtual_machine", false) ? {
      name        = substr(join("-", compact([local.prefix, "vm", local.suffix])), 0, 15)
      name_unique = substr(join("-", compact([local.prefix, "vm", local.suffix_unique])), 0, 15)
      dashes      = true
      slug        = "vm"
      min_length  = 1
      max_length  = 15
      scope       = "resourceGroup"
      regex       = "^[^\\/\"\\[\\]:|<>+=;,?*@&_][^\\/\"\\[\\]:|<>+=;,?*@&]+[^\\/\"\\[\\]:|<>+=;,?*@&.-]$"
      description = "Virtual Machine"
    } : null
    virtual_machine_extension = var.enabled_all || lookup(var.enabled, "virtual_machine_extension", false) ? {
      name        = substr(join("-", compact([local.prefix, "vmx", local.suffix])), 0, 80)
      name_unique = substr(join("-", compact([local.prefix, "vmx", local.suffix_unique])), 0, 80)
      dashes      = true
      slug        = "vmx"
      min_length  = 1
      max_length  = 80
      scope       = "parent"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9_]$"
      description = "Virtual Machine Extension"
    } : null
    virtual_machine_scale_set = var.enabled_all || lookup(var.enabled, "virtual_machine_scale_set", false) ? {
      name        = substr(join("-", compact([local.prefix, "vmss", local.suffix])), 0, 15)
      name_unique = substr(join("-", compact([local.prefix, "vmss", local.suffix_unique])), 0, 15)
      dashes      = true
      slug        = "vmss"
      min_length  = 1
      max_length  = 15
      scope       = "resourceGroup"
      regex       = "^[^\\/\"\\[\\]:|<>+=;,?*@&_][^\\/\"\\[\\]:|<>+=;,?*@&]+[^\\/\"\\[\\]:|<>+=;,?*@&.-]$"
      description = "Virtual Machine Scale Set"
    } : null
    virtual_machine_scale_set_extension = var.enabled_all || lookup(var.enabled, "virtual_machine_scale_set_extension", false) ? {
      name        = substr(join("-", compact([local.prefix, "vmssx", local.suffix])), 0, 80)
      name_unique = substr(join("-", compact([local.prefix, "vmssx", local.suffix_unique])), 0, 80)
      dashes      = true
      slug        = "vmssx"
      min_length  = 1
      max_length  = 80
      scope       = "parent"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9_]$"
      description = "Virtual Machine Scale Set Extension"
    } : null
    virtual_network = var.enabled_all || lookup(var.enabled, "virtual_network", false) ? {
      name        = substr(join("-", compact([local.prefix, "vnet", local.suffix])), 0, 64)
      name_unique = substr(join("-", compact([local.prefix, "vnet", local.suffix_unique])), 0, 64)
      dashes      = true
      slug        = "vnet"
      min_length  = 2
      max_length  = 64
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9_]$"
      description = "Virtual Network"
    } : null
    virtual_network_gateway = var.enabled_all || lookup(var.enabled, "virtual_network_gateway", false) ? {
      name        = substr(join("-", compact([local.prefix, "vgw", local.suffix])), 0, 80)
      name_unique = substr(join("-", compact([local.prefix, "vgw", local.suffix_unique])), 0, 80)
      dashes      = true
      slug        = "vgw"
      min_length  = 1
      max_length  = 80
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9_]$"
      description = "Virtual Network Gateway"
    } : null
    virtual_network_gateway_connection = var.enabled_all || lookup(var.enabled, "virtual_network_gateway_connection", false) ? {
      name        = substr(join("-", compact([local.prefix, "vcn", local.suffix])), 0, 80)
      name_unique = substr(join("-", compact([local.prefix, "vcn", local.suffix_unique])), 0, 80)
      dashes      = true
      slug        = "vcn"
      min_length  = 1
      max_length  = 80
      scope       = "resourceGroup"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9_]$"
      description = "Virtual Network Gateway Connection"
    } : null
    virtual_network_peering = var.enabled_all || lookup(var.enabled, "virtual_network_peering", false) ? {
      name        = substr(join("-", compact([local.prefix, "vpeer", local.suffix])), 0, 80)
      name_unique = substr(join("-", compact([local.prefix, "vpeer", local.suffix_unique])), 0, 80)
      dashes      = true
      slug        = "vpeer"
      min_length  = 1
      max_length  = 80
      scope       = "parent"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9_]$"
      description = "Virtual Network Peering"
    } : null
    virtual_wan = var.enabled_all || lookup(var.enabled, "virtual_wan", false) ? {
      name        = substr(join("-", compact([local.prefix, "vwan", local.suffix])), 0, 80)
      name_unique = substr(join("-", compact([local.prefix, "vwan", local.suffix_unique])), 0, 80)
      dashes      = true
      slug        = "vwan"
      min_length  = 1
      max_length  = 80
      scope       = "parent"
      regex       = "^[a-zA-Z0-9][a-zA-Z0-9-._]+[a-zA-Z0-9_]$"
      description = "Virtual Wan"
    } : null
    windows_virtual_machine = var.enabled_all || lookup(var.enabled, "windows_virtual_machine", false) ? {
      name        = substr(join("-", compact([local.prefix, "vm", local.suffix])), 0, 15)
      name_unique = substr(join("-", compact([local.prefix, "vm", local.suffix_unique])), 0, 15)
      dashes      = true
      slug        = "vm"
      min_length  = 1
      max_length  = 15
      scope       = "resourceGroup"
      regex       = "^[^\\/\"\\[\\]:|<>+=;,?*@&_][^\\/\"\\[\\]:|<>+=;,?*@&]+[^\\/\"\\[\\]:|<>+=;,?*@&.-]$"
      description = "Windows Virtual Machine"
    } : null
    windows_virtual_machine_scale_set = var.enabled_all || lookup(var.enabled, "windows_virtual_machine_scale_set", false) ? {
      name        = substr(join("-", compact([local.prefix, "vmss", local.suffix])), 0, 15)
      name_unique = substr(join("-", compact([local.prefix, "vmss", local.suffix_unique])), 0, 15)
      dashes      = true
      slug        = "vmss"
      min_length  = 1
      max_length  = 15
      scope       = "resourceGroup"
      regex       = "^[^\\/\"\\[\\]:|<>+=;,?*@&_][^\\/\"\\[\\]:|<>+=;,?*@&]+[^\\/\"\\[\\]:|<>+=;,?*@&.-]$"
      description = "Windows Virtual Machine Scale Set"
    } : null
  }
  validation = {
    analysis_services_server = lookup(var.enabled, "analysis_services_server", false) ? {
      valid_name        = length(regexall(local.az.analysis_services_server.regex, local.az.analysis_services_server.name)) > 0 && length(local.az.analysis_services_server.name) > local.az.analysis_services_server.min_length
      valid_name_unique = length(regexall(local.az.analysis_services_server.regex, local.az.analysis_services_server.name_unique)) > 0
    } : null
    api_management = lookup(var.enabled, "api_management", false) ? {
      valid_name        = length(regexall(local.az.api_management.regex, local.az.api_management.name)) > 0 && length(local.az.api_management.name) > local.az.api_management.min_length
      valid_name_unique = length(regexall(local.az.api_management.regex, local.az.api_management.name_unique)) > 0
    } : null
    app_configuration = lookup(var.enabled, "app_configuration", false) ? {
      valid_name        = length(regexall(local.az.app_configuration.regex, local.az.app_configuration.name)) > 0 && length(local.az.app_configuration.name) > local.az.app_configuration.min_length
      valid_name_unique = length(regexall(local.az.app_configuration.regex, local.az.app_configuration.name_unique)) > 0
    } : null
    app_service = lookup(var.enabled, "app_service", false) ? {
      valid_name        = length(regexall(local.az.app_service.regex, local.az.app_service.name)) > 0 && length(local.az.app_service.name) > local.az.app_service.min_length
      valid_name_unique = length(regexall(local.az.app_service.regex, local.az.app_service.name_unique)) > 0
    } : null
    app_service_environment = lookup(var.enabled, "app_service_environment", false) ? {
      valid_name        = length(regexall(local.az.app_service_environment.regex, local.az.app_service_environment.name)) > 0 && length(local.az.app_service_environment.name) > local.az.app_service_environment.min_length
      valid_name_unique = length(regexall(local.az.app_service_environment.regex, local.az.app_service_environment.name_unique)) > 0
    } : null
    app_service_plan = lookup(var.enabled, "app_service_plan", false) ? {
      valid_name        = length(regexall(local.az.app_service_plan.regex, local.az.app_service_plan.name)) > 0 && length(local.az.app_service_plan.name) > local.az.app_service_plan.min_length
      valid_name_unique = length(regexall(local.az.app_service_plan.regex, local.az.app_service_plan.name_unique)) > 0
    } : null
    application_gateway = lookup(var.enabled, "application_gateway", false) ? {
      valid_name        = length(regexall(local.az.application_gateway.regex, local.az.application_gateway.name)) > 0 && length(local.az.application_gateway.name) > local.az.application_gateway.min_length
      valid_name_unique = length(regexall(local.az.application_gateway.regex, local.az.application_gateway.name_unique)) > 0
    } : null
    application_insights = lookup(var.enabled, "application_insights", false) ? {
      valid_name        = length(regexall(local.az.application_insights.regex, local.az.application_insights.name)) > 0 && length(local.az.application_insights.name) > local.az.application_insights.min_length
      valid_name_unique = length(regexall(local.az.application_insights.regex, local.az.application_insights.name_unique)) > 0
    } : null
    application_security_group = lookup(var.enabled, "application_security_group", false) ? {
      valid_name        = length(regexall(local.az.application_security_group.regex, local.az.application_security_group.name)) > 0 && length(local.az.application_security_group.name) > local.az.application_security_group.min_length
      valid_name_unique = length(regexall(local.az.application_security_group.regex, local.az.application_security_group.name_unique)) > 0
    } : null
    automation_account = lookup(var.enabled, "automation_account", false) ? {
      valid_name        = length(regexall(local.az.automation_account.regex, local.az.automation_account.name)) > 0 && length(local.az.automation_account.name) > local.az.automation_account.min_length
      valid_name_unique = length(regexall(local.az.automation_account.regex, local.az.automation_account.name_unique)) > 0
    } : null
    automation_certificate = lookup(var.enabled, "automation_certificate", false) ? {
      valid_name        = length(regexall(local.az.automation_certificate.regex, local.az.automation_certificate.name)) > 0 && length(local.az.automation_certificate.name) > local.az.automation_certificate.min_length
      valid_name_unique = length(regexall(local.az.automation_certificate.regex, local.az.automation_certificate.name_unique)) > 0
    } : null
    automation_credential = lookup(var.enabled, "automation_credential", false) ? {
      valid_name        = length(regexall(local.az.automation_credential.regex, local.az.automation_credential.name)) > 0 && length(local.az.automation_credential.name) > local.az.automation_credential.min_length
      valid_name_unique = length(regexall(local.az.automation_credential.regex, local.az.automation_credential.name_unique)) > 0
    } : null
    automation_runbook = lookup(var.enabled, "automation_runbook", false) ? {
      valid_name        = length(regexall(local.az.automation_runbook.regex, local.az.automation_runbook.name)) > 0 && length(local.az.automation_runbook.name) > local.az.automation_runbook.min_length
      valid_name_unique = length(regexall(local.az.automation_runbook.regex, local.az.automation_runbook.name_unique)) > 0
    } : null
    automation_schedule = lookup(var.enabled, "automation_schedule", false) ? {
      valid_name        = length(regexall(local.az.automation_schedule.regex, local.az.automation_schedule.name)) > 0 && length(local.az.automation_schedule.name) > local.az.automation_schedule.min_length
      valid_name_unique = length(regexall(local.az.automation_schedule.regex, local.az.automation_schedule.name_unique)) > 0
    } : null
    automation_variable = lookup(var.enabled, "automation_variable", false) ? {
      valid_name        = length(regexall(local.az.automation_variable.regex, local.az.automation_variable.name)) > 0 && length(local.az.automation_variable.name) > local.az.automation_variable.min_length
      valid_name_unique = length(regexall(local.az.automation_variable.regex, local.az.automation_variable.name_unique)) > 0
    } : null
    availability_set = lookup(var.enabled, "availability_set", false) ? {
      valid_name        = length(regexall(local.az.availability_set.regex, local.az.availability_set.name)) > 0 && length(local.az.availability_set.name) > local.az.availability_set.min_length
      valid_name_unique = length(regexall(local.az.availability_set.regex, local.az.availability_set.name_unique)) > 0
    } : null
    bastion_host = lookup(var.enabled, "bastion_host", false) ? {
      valid_name        = length(regexall(local.az.bastion_host.regex, local.az.bastion_host.name)) > 0 && length(local.az.bastion_host.name) > local.az.bastion_host.min_length
      valid_name_unique = length(regexall(local.az.bastion_host.regex, local.az.bastion_host.name_unique)) > 0
    } : null
    batch_account = lookup(var.enabled, "batch_account", false) ? {
      valid_name        = length(regexall(local.az.batch_account.regex, local.az.batch_account.name)) > 0 && length(local.az.batch_account.name) > local.az.batch_account.min_length
      valid_name_unique = length(regexall(local.az.batch_account.regex, local.az.batch_account.name_unique)) > 0
    } : null
    batch_application = lookup(var.enabled, "batch_application", false) ? {
      valid_name        = length(regexall(local.az.batch_application.regex, local.az.batch_application.name)) > 0 && length(local.az.batch_application.name) > local.az.batch_application.min_length
      valid_name_unique = length(regexall(local.az.batch_application.regex, local.az.batch_application.name_unique)) > 0
    } : null
    batch_certificate = lookup(var.enabled, "batch_certificate", false) ? {
      valid_name        = length(regexall(local.az.batch_certificate.regex, local.az.batch_certificate.name)) > 0 && length(local.az.batch_certificate.name) > local.az.batch_certificate.min_length
      valid_name_unique = length(regexall(local.az.batch_certificate.regex, local.az.batch_certificate.name_unique)) > 0
    } : null
    batch_pool = lookup(var.enabled, "batch_pool", false) ? {
      valid_name        = length(regexall(local.az.batch_pool.regex, local.az.batch_pool.name)) > 0 && length(local.az.batch_pool.name) > local.az.batch_pool.min_length
      valid_name_unique = length(regexall(local.az.batch_pool.regex, local.az.batch_pool.name_unique)) > 0
    } : null
    bot_channel_directline = lookup(var.enabled, "bot_channel_directline", false) ? {
      valid_name        = length(regexall(local.az.bot_channel_directline.regex, local.az.bot_channel_directline.name)) > 0 && length(local.az.bot_channel_directline.name) > local.az.bot_channel_directline.min_length
      valid_name_unique = length(regexall(local.az.bot_channel_directline.regex, local.az.bot_channel_directline.name_unique)) > 0
    } : null
    bot_channel_email = lookup(var.enabled, "bot_channel_email", false) ? {
      valid_name        = length(regexall(local.az.bot_channel_email.regex, local.az.bot_channel_email.name)) > 0 && length(local.az.bot_channel_email.name) > local.az.bot_channel_email.min_length
      valid_name_unique = length(regexall(local.az.bot_channel_email.regex, local.az.bot_channel_email.name_unique)) > 0
    } : null
    bot_channel_ms_teams = lookup(var.enabled, "bot_channel_ms_teams", false) ? {
      valid_name        = length(regexall(local.az.bot_channel_ms_teams.regex, local.az.bot_channel_ms_teams.name)) > 0 && length(local.az.bot_channel_ms_teams.name) > local.az.bot_channel_ms_teams.min_length
      valid_name_unique = length(regexall(local.az.bot_channel_ms_teams.regex, local.az.bot_channel_ms_teams.name_unique)) > 0
    } : null
    bot_channel_slack = lookup(var.enabled, "bot_channel_slack", false) ? {
      valid_name        = length(regexall(local.az.bot_channel_slack.regex, local.az.bot_channel_slack.name)) > 0 && length(local.az.bot_channel_slack.name) > local.az.bot_channel_slack.min_length
      valid_name_unique = length(regexall(local.az.bot_channel_slack.regex, local.az.bot_channel_slack.name_unique)) > 0
    } : null
    bot_channels_registration = lookup(var.enabled, "bot_channels_registration", false) ? {
      valid_name        = length(regexall(local.az.bot_channels_registration.regex, local.az.bot_channels_registration.name)) > 0 && length(local.az.bot_channels_registration.name) > local.az.bot_channels_registration.min_length
      valid_name_unique = length(regexall(local.az.bot_channels_registration.regex, local.az.bot_channels_registration.name_unique)) > 0
    } : null
    bot_connection = lookup(var.enabled, "bot_connection", false) ? {
      valid_name        = length(regexall(local.az.bot_connection.regex, local.az.bot_connection.name)) > 0 && length(local.az.bot_connection.name) > local.az.bot_connection.min_length
      valid_name_unique = length(regexall(local.az.bot_connection.regex, local.az.bot_connection.name_unique)) > 0
    } : null
    bot_web_app = lookup(var.enabled, "bot_web_app", false) ? {
      valid_name        = length(regexall(local.az.bot_web_app.regex, local.az.bot_web_app.name)) > 0 && length(local.az.bot_web_app.name) > local.az.bot_web_app.min_length
      valid_name_unique = length(regexall(local.az.bot_web_app.regex, local.az.bot_web_app.name_unique)) > 0
    } : null
    cdn_endpoint = lookup(var.enabled, "cdn_endpoint", false) ? {
      valid_name        = length(regexall(local.az.cdn_endpoint.regex, local.az.cdn_endpoint.name)) > 0 && length(local.az.cdn_endpoint.name) > local.az.cdn_endpoint.min_length
      valid_name_unique = length(regexall(local.az.cdn_endpoint.regex, local.az.cdn_endpoint.name_unique)) > 0
    } : null
    cdn_profile = lookup(var.enabled, "cdn_profile", false) ? {
      valid_name        = length(regexall(local.az.cdn_profile.regex, local.az.cdn_profile.name)) > 0 && length(local.az.cdn_profile.name) > local.az.cdn_profile.min_length
      valid_name_unique = length(regexall(local.az.cdn_profile.regex, local.az.cdn_profile.name_unique)) > 0
    } : null
    cognitive_account = lookup(var.enabled, "cognitive_account", false) ? {
      valid_name        = length(regexall(local.az.cognitive_account.regex, local.az.cognitive_account.name)) > 0 && length(local.az.cognitive_account.name) > local.az.cognitive_account.min_length
      valid_name_unique = length(regexall(local.az.cognitive_account.regex, local.az.cognitive_account.name_unique)) > 0
    } : null
    container_app = lookup(var.enabled, "container_app", false) ? {
      valid_name        = length(regexall(local.az.container_app.regex, local.az.container_app.name)) > 0 && length(local.az.container_app.name) > local.az.container_app.min_length
      valid_name_unique = length(regexall(local.az.container_app.regex, local.az.container_app.name_unique)) > 0
    } : null
    container_app_environment = lookup(var.enabled, "container_app_environment", false) ? {
      valid_name        = length(regexall(local.az.container_app_environment.regex, local.az.container_app_environment.name)) > 0 && length(local.az.container_app_environment.name) > local.az.container_app_environment.min_length
      valid_name_unique = length(regexall(local.az.container_app_environment.regex, local.az.container_app_environment.name_unique)) > 0
    } : null
    container_group = lookup(var.enabled, "container_group", false) ? {
      valid_name        = length(regexall(local.az.container_group.regex, local.az.container_group.name)) > 0 && length(local.az.container_group.name) > local.az.container_group.min_length
      valid_name_unique = length(regexall(local.az.container_group.regex, local.az.container_group.name_unique)) > 0
    } : null
    container_registry = lookup(var.enabled, "container_registry", false) ? {
      valid_name        = length(regexall(local.az.container_registry.regex, local.az.container_registry.name)) > 0 && length(local.az.container_registry.name) > local.az.container_registry.min_length
      valid_name_unique = length(regexall(local.az.container_registry.regex, local.az.container_registry.name_unique)) > 0
    } : null
    container_registry_webhook = lookup(var.enabled, "container_registry_webhook", false) ? {
      valid_name        = length(regexall(local.az.container_registry_webhook.regex, local.az.container_registry_webhook.name)) > 0 && length(local.az.container_registry_webhook.name) > local.az.container_registry_webhook.min_length
      valid_name_unique = length(regexall(local.az.container_registry_webhook.regex, local.az.container_registry_webhook.name_unique)) > 0
    } : null
    cosmosdb_account = lookup(var.enabled, "cosmosdb_account", false) ? {
      valid_name        = length(regexall(local.az.cosmosdb_account.regex, local.az.cosmosdb_account.name)) > 0 && length(local.az.cosmosdb_account.name) > local.az.cosmosdb_account.min_length
      valid_name_unique = length(regexall(local.az.cosmosdb_account.regex, local.az.cosmosdb_account.name_unique)) > 0
    } : null
    cosmosdb_cassandra_cluster = lookup(var.enabled, "cosmosdb_cassandra_cluster", false) ? {
      valid_name        = length(regexall(local.az.cosmosdb_cassandra_cluster.regex, local.az.cosmosdb_cassandra_cluster.name)) > 0 && length(local.az.cosmosdb_cassandra_cluster.name) > local.az.cosmosdb_cassandra_cluster.min_length
      valid_name_unique = length(regexall(local.az.cosmosdb_cassandra_cluster.regex, local.az.cosmosdb_cassandra_cluster.name_unique)) > 0
    } : null
    cosmosdb_cassandra_datacenter = lookup(var.enabled, "cosmosdb_cassandra_datacenter", false) ? {
      valid_name        = length(regexall(local.az.cosmosdb_cassandra_datacenter.regex, local.az.cosmosdb_cassandra_datacenter.name)) > 0 && length(local.az.cosmosdb_cassandra_datacenter.name) > local.az.cosmosdb_cassandra_datacenter.min_length
      valid_name_unique = length(regexall(local.az.cosmosdb_cassandra_datacenter.regex, local.az.cosmosdb_cassandra_datacenter.name_unique)) > 0
    } : null
    cosmosdb_postgres = lookup(var.enabled, "cosmosdb_postgres", false) ? {
      valid_name        = length(regexall(local.az.cosmosdb_postgres.regex, local.az.cosmosdb_postgres.name)) > 0 && length(local.az.cosmosdb_postgres.name) > local.az.cosmosdb_postgres.min_length
      valid_name_unique = length(regexall(local.az.cosmosdb_postgres.regex, local.az.cosmosdb_postgres.name_unique)) > 0
    } : null
    custom_provider = lookup(var.enabled, "custom_provider", false) ? {
      valid_name        = length(regexall(local.az.custom_provider.regex, local.az.custom_provider.name)) > 0 && length(local.az.custom_provider.name) > local.az.custom_provider.min_length
      valid_name_unique = length(regexall(local.az.custom_provider.regex, local.az.custom_provider.name_unique)) > 0
    } : null
    dashboard = lookup(var.enabled, "dashboard", false) ? {
      valid_name        = length(regexall(local.az.dashboard.regex, local.az.dashboard.name)) > 0 && length(local.az.dashboard.name) > local.az.dashboard.min_length
      valid_name_unique = length(regexall(local.az.dashboard.regex, local.az.dashboard.name_unique)) > 0
    } : null
    data_factory = lookup(var.enabled, "data_factory", false) ? {
      valid_name        = length(regexall(local.az.data_factory.regex, local.az.data_factory.name)) > 0 && length(local.az.data_factory.name) > local.az.data_factory.min_length
      valid_name_unique = length(regexall(local.az.data_factory.regex, local.az.data_factory.name_unique)) > 0
    } : null
    data_factory_dataset_mysql = lookup(var.enabled, "data_factory_dataset_mysql", false) ? {
      valid_name        = length(regexall(local.az.data_factory_dataset_mysql.regex, local.az.data_factory_dataset_mysql.name)) > 0 && length(local.az.data_factory_dataset_mysql.name) > local.az.data_factory_dataset_mysql.min_length
      valid_name_unique = length(regexall(local.az.data_factory_dataset_mysql.regex, local.az.data_factory_dataset_mysql.name_unique)) > 0
    } : null
    data_factory_dataset_postgresql = lookup(var.enabled, "data_factory_dataset_postgresql", false) ? {
      valid_name        = length(regexall(local.az.data_factory_dataset_postgresql.regex, local.az.data_factory_dataset_postgresql.name)) > 0 && length(local.az.data_factory_dataset_postgresql.name) > local.az.data_factory_dataset_postgresql.min_length
      valid_name_unique = length(regexall(local.az.data_factory_dataset_postgresql.regex, local.az.data_factory_dataset_postgresql.name_unique)) > 0
    } : null
    data_factory_dataset_sql_server_table = lookup(var.enabled, "data_factory_dataset_sql_server_table", false) ? {
      valid_name        = length(regexall(local.az.data_factory_dataset_sql_server_table.regex, local.az.data_factory_dataset_sql_server_table.name)) > 0 && length(local.az.data_factory_dataset_sql_server_table.name) > local.az.data_factory_dataset_sql_server_table.min_length
      valid_name_unique = length(regexall(local.az.data_factory_dataset_sql_server_table.regex, local.az.data_factory_dataset_sql_server_table.name_unique)) > 0
    } : null
    data_factory_integration_runtime_managed = lookup(var.enabled, "data_factory_integration_runtime_managed", false) ? {
      valid_name        = length(regexall(local.az.data_factory_integration_runtime_managed.regex, local.az.data_factory_integration_runtime_managed.name)) > 0 && length(local.az.data_factory_integration_runtime_managed.name) > local.az.data_factory_integration_runtime_managed.min_length
      valid_name_unique = length(regexall(local.az.data_factory_integration_runtime_managed.regex, local.az.data_factory_integration_runtime_managed.name_unique)) > 0
    } : null
    data_factory_linked_service_data_lake_storage_gen2 = lookup(var.enabled, "data_factory_linked_service_data_lake_storage_gen2", false) ? {
      valid_name        = length(regexall(local.az.data_factory_linked_service_data_lake_storage_gen2.regex, local.az.data_factory_linked_service_data_lake_storage_gen2.name)) > 0 && length(local.az.data_factory_linked_service_data_lake_storage_gen2.name) > local.az.data_factory_linked_service_data_lake_storage_gen2.min_length
      valid_name_unique = length(regexall(local.az.data_factory_linked_service_data_lake_storage_gen2.regex, local.az.data_factory_linked_service_data_lake_storage_gen2.name_unique)) > 0
    } : null
    data_factory_linked_service_key_vault = lookup(var.enabled, "data_factory_linked_service_key_vault", false) ? {
      valid_name        = length(regexall(local.az.data_factory_linked_service_key_vault.regex, local.az.data_factory_linked_service_key_vault.name)) > 0 && length(local.az.data_factory_linked_service_key_vault.name) > local.az.data_factory_linked_service_key_vault.min_length
      valid_name_unique = length(regexall(local.az.data_factory_linked_service_key_vault.regex, local.az.data_factory_linked_service_key_vault.name_unique)) > 0
    } : null
    data_factory_linked_service_mysql = lookup(var.enabled, "data_factory_linked_service_mysql", false) ? {
      valid_name        = length(regexall(local.az.data_factory_linked_service_mysql.regex, local.az.data_factory_linked_service_mysql.name)) > 0 && length(local.az.data_factory_linked_service_mysql.name) > local.az.data_factory_linked_service_mysql.min_length
      valid_name_unique = length(regexall(local.az.data_factory_linked_service_mysql.regex, local.az.data_factory_linked_service_mysql.name_unique)) > 0
    } : null
    data_factory_linked_service_postgresql = lookup(var.enabled, "data_factory_linked_service_postgresql", false) ? {
      valid_name        = length(regexall(local.az.data_factory_linked_service_postgresql.regex, local.az.data_factory_linked_service_postgresql.name)) > 0 && length(local.az.data_factory_linked_service_postgresql.name) > local.az.data_factory_linked_service_postgresql.min_length
      valid_name_unique = length(regexall(local.az.data_factory_linked_service_postgresql.regex, local.az.data_factory_linked_service_postgresql.name_unique)) > 0
    } : null
    data_factory_linked_service_sql_server = lookup(var.enabled, "data_factory_linked_service_sql_server", false) ? {
      valid_name        = length(regexall(local.az.data_factory_linked_service_sql_server.regex, local.az.data_factory_linked_service_sql_server.name)) > 0 && length(local.az.data_factory_linked_service_sql_server.name) > local.az.data_factory_linked_service_sql_server.min_length
      valid_name_unique = length(regexall(local.az.data_factory_linked_service_sql_server.regex, local.az.data_factory_linked_service_sql_server.name_unique)) > 0
    } : null
    data_factory_pipeline = lookup(var.enabled, "data_factory_pipeline", false) ? {
      valid_name        = length(regexall(local.az.data_factory_pipeline.regex, local.az.data_factory_pipeline.name)) > 0 && length(local.az.data_factory_pipeline.name) > local.az.data_factory_pipeline.min_length
      valid_name_unique = length(regexall(local.az.data_factory_pipeline.regex, local.az.data_factory_pipeline.name_unique)) > 0
    } : null
    data_factory_trigger_schedule = lookup(var.enabled, "data_factory_trigger_schedule", false) ? {
      valid_name        = length(regexall(local.az.data_factory_trigger_schedule.regex, local.az.data_factory_trigger_schedule.name)) > 0 && length(local.az.data_factory_trigger_schedule.name) > local.az.data_factory_trigger_schedule.min_length
      valid_name_unique = length(regexall(local.az.data_factory_trigger_schedule.regex, local.az.data_factory_trigger_schedule.name_unique)) > 0
    } : null
    data_lake_analytics_account = lookup(var.enabled, "data_lake_analytics_account", false) ? {
      valid_name        = length(regexall(local.az.data_lake_analytics_account.regex, local.az.data_lake_analytics_account.name)) > 0 && length(local.az.data_lake_analytics_account.name) > local.az.data_lake_analytics_account.min_length
      valid_name_unique = length(regexall(local.az.data_lake_analytics_account.regex, local.az.data_lake_analytics_account.name_unique)) > 0
    } : null
    data_lake_analytics_firewall_rule = lookup(var.enabled, "data_lake_analytics_firewall_rule", false) ? {
      valid_name        = length(regexall(local.az.data_lake_analytics_firewall_rule.regex, local.az.data_lake_analytics_firewall_rule.name)) > 0 && length(local.az.data_lake_analytics_firewall_rule.name) > local.az.data_lake_analytics_firewall_rule.min_length
      valid_name_unique = length(regexall(local.az.data_lake_analytics_firewall_rule.regex, local.az.data_lake_analytics_firewall_rule.name_unique)) > 0
    } : null
    data_lake_store = lookup(var.enabled, "data_lake_store", false) ? {
      valid_name        = length(regexall(local.az.data_lake_store.regex, local.az.data_lake_store.name)) > 0 && length(local.az.data_lake_store.name) > local.az.data_lake_store.min_length
      valid_name_unique = length(regexall(local.az.data_lake_store.regex, local.az.data_lake_store.name_unique)) > 0
    } : null
    data_lake_store_firewall_rule = lookup(var.enabled, "data_lake_store_firewall_rule", false) ? {
      valid_name        = length(regexall(local.az.data_lake_store_firewall_rule.regex, local.az.data_lake_store_firewall_rule.name)) > 0 && length(local.az.data_lake_store_firewall_rule.name) > local.az.data_lake_store_firewall_rule.min_length
      valid_name_unique = length(regexall(local.az.data_lake_store_firewall_rule.regex, local.az.data_lake_store_firewall_rule.name_unique)) > 0
    } : null
    database_migration_project = lookup(var.enabled, "database_migration_project", false) ? {
      valid_name        = length(regexall(local.az.database_migration_project.regex, local.az.database_migration_project.name)) > 0 && length(local.az.database_migration_project.name) > local.az.database_migration_project.min_length
      valid_name_unique = length(regexall(local.az.database_migration_project.regex, local.az.database_migration_project.name_unique)) > 0
    } : null
    database_migration_service = lookup(var.enabled, "database_migration_service", false) ? {
      valid_name        = length(regexall(local.az.database_migration_service.regex, local.az.database_migration_service.name)) > 0 && length(local.az.database_migration_service.name) > local.az.database_migration_service.min_length
      valid_name_unique = length(regexall(local.az.database_migration_service.regex, local.az.database_migration_service.name_unique)) > 0
    } : null
    databricks_cluster = lookup(var.enabled, "databricks_cluster", false) ? {
      valid_name        = length(regexall(local.az.databricks_cluster.regex, local.az.databricks_cluster.name)) > 0 && length(local.az.databricks_cluster.name) > local.az.databricks_cluster.min_length
      valid_name_unique = length(regexall(local.az.databricks_cluster.regex, local.az.databricks_cluster.name_unique)) > 0
    } : null
    databricks_high_concurrency_cluster = lookup(var.enabled, "databricks_high_concurrency_cluster", false) ? {
      valid_name        = length(regexall(local.az.databricks_high_concurrency_cluster.regex, local.az.databricks_high_concurrency_cluster.name)) > 0 && length(local.az.databricks_high_concurrency_cluster.name) > local.az.databricks_high_concurrency_cluster.min_length
      valid_name_unique = length(regexall(local.az.databricks_high_concurrency_cluster.regex, local.az.databricks_high_concurrency_cluster.name_unique)) > 0
    } : null
    databricks_standard_cluster = lookup(var.enabled, "databricks_standard_cluster", false) ? {
      valid_name        = length(regexall(local.az.databricks_standard_cluster.regex, local.az.databricks_standard_cluster.name)) > 0 && length(local.az.databricks_standard_cluster.name) > local.az.databricks_standard_cluster.min_length
      valid_name_unique = length(regexall(local.az.databricks_standard_cluster.regex, local.az.databricks_standard_cluster.name_unique)) > 0
    } : null
    databricks_workspace = lookup(var.enabled, "databricks_workspace", false) ? {
      valid_name        = length(regexall(local.az.databricks_workspace.regex, local.az.databricks_workspace.name)) > 0 && length(local.az.databricks_workspace.name) > local.az.databricks_workspace.min_length
      valid_name_unique = length(regexall(local.az.databricks_workspace.regex, local.az.databricks_workspace.name_unique)) > 0
    } : null
    dev_test_lab = lookup(var.enabled, "dev_test_lab", false) ? {
      valid_name        = length(regexall(local.az.dev_test_lab.regex, local.az.dev_test_lab.name)) > 0 && length(local.az.dev_test_lab.name) > local.az.dev_test_lab.min_length
      valid_name_unique = length(regexall(local.az.dev_test_lab.regex, local.az.dev_test_lab.name_unique)) > 0
    } : null
    dev_test_linux_virtual_machine = lookup(var.enabled, "dev_test_linux_virtual_machine", false) ? {
      valid_name        = length(regexall(local.az.dev_test_linux_virtual_machine.regex, local.az.dev_test_linux_virtual_machine.name)) > 0 && length(local.az.dev_test_linux_virtual_machine.name) > local.az.dev_test_linux_virtual_machine.min_length
      valid_name_unique = length(regexall(local.az.dev_test_linux_virtual_machine.regex, local.az.dev_test_linux_virtual_machine.name_unique)) > 0
    } : null
    dev_test_windows_virtual_machine = lookup(var.enabled, "dev_test_windows_virtual_machine", false) ? {
      valid_name        = length(regexall(local.az.dev_test_windows_virtual_machine.regex, local.az.dev_test_windows_virtual_machine.name)) > 0 && length(local.az.dev_test_windows_virtual_machine.name) > local.az.dev_test_windows_virtual_machine.min_length
      valid_name_unique = length(regexall(local.az.dev_test_windows_virtual_machine.regex, local.az.dev_test_windows_virtual_machine.name_unique)) > 0
    } : null
    disk_encryption_set = lookup(var.enabled, "disk_encryption_set", false) ? {
      valid_name        = length(regexall(local.az.disk_encryption_set.regex, local.az.disk_encryption_set.name)) > 0 && length(local.az.disk_encryption_set.name) > local.az.disk_encryption_set.min_length
      valid_name_unique = length(regexall(local.az.disk_encryption_set.regex, local.az.disk_encryption_set.name_unique)) > 0
    } : null
    dns_a_record = lookup(var.enabled, "dns_a_record", false) ? {
      valid_name        = length(regexall(local.az.dns_a_record.regex, local.az.dns_a_record.name)) > 0 && length(local.az.dns_a_record.name) > local.az.dns_a_record.min_length
      valid_name_unique = length(regexall(local.az.dns_a_record.regex, local.az.dns_a_record.name_unique)) > 0
    } : null
    dns_aaaa_record = lookup(var.enabled, "dns_aaaa_record", false) ? {
      valid_name        = length(regexall(local.az.dns_aaaa_record.regex, local.az.dns_aaaa_record.name)) > 0 && length(local.az.dns_aaaa_record.name) > local.az.dns_aaaa_record.min_length
      valid_name_unique = length(regexall(local.az.dns_aaaa_record.regex, local.az.dns_aaaa_record.name_unique)) > 0
    } : null
    dns_caa_record = lookup(var.enabled, "dns_caa_record", false) ? {
      valid_name        = length(regexall(local.az.dns_caa_record.regex, local.az.dns_caa_record.name)) > 0 && length(local.az.dns_caa_record.name) > local.az.dns_caa_record.min_length
      valid_name_unique = length(regexall(local.az.dns_caa_record.regex, local.az.dns_caa_record.name_unique)) > 0
    } : null
    dns_cname_record = lookup(var.enabled, "dns_cname_record", false) ? {
      valid_name        = length(regexall(local.az.dns_cname_record.regex, local.az.dns_cname_record.name)) > 0 && length(local.az.dns_cname_record.name) > local.az.dns_cname_record.min_length
      valid_name_unique = length(regexall(local.az.dns_cname_record.regex, local.az.dns_cname_record.name_unique)) > 0
    } : null
    dns_mx_record = lookup(var.enabled, "dns_mx_record", false) ? {
      valid_name        = length(regexall(local.az.dns_mx_record.regex, local.az.dns_mx_record.name)) > 0 && length(local.az.dns_mx_record.name) > local.az.dns_mx_record.min_length
      valid_name_unique = length(regexall(local.az.dns_mx_record.regex, local.az.dns_mx_record.name_unique)) > 0
    } : null
    dns_ns_record = lookup(var.enabled, "dns_ns_record", false) ? {
      valid_name        = length(regexall(local.az.dns_ns_record.regex, local.az.dns_ns_record.name)) > 0 && length(local.az.dns_ns_record.name) > local.az.dns_ns_record.min_length
      valid_name_unique = length(regexall(local.az.dns_ns_record.regex, local.az.dns_ns_record.name_unique)) > 0
    } : null
    dns_ptr_record = lookup(var.enabled, "dns_ptr_record", false) ? {
      valid_name        = length(regexall(local.az.dns_ptr_record.regex, local.az.dns_ptr_record.name)) > 0 && length(local.az.dns_ptr_record.name) > local.az.dns_ptr_record.min_length
      valid_name_unique = length(regexall(local.az.dns_ptr_record.regex, local.az.dns_ptr_record.name_unique)) > 0
    } : null
    dns_txt_record = lookup(var.enabled, "dns_txt_record", false) ? {
      valid_name        = length(regexall(local.az.dns_txt_record.regex, local.az.dns_txt_record.name)) > 0 && length(local.az.dns_txt_record.name) > local.az.dns_txt_record.min_length
      valid_name_unique = length(regexall(local.az.dns_txt_record.regex, local.az.dns_txt_record.name_unique)) > 0
    } : null
    dns_zone = lookup(var.enabled, "dns_zone", false) ? {
      valid_name        = length(regexall(local.az.dns_zone.regex, local.az.dns_zone.name)) > 0 && length(local.az.dns_zone.name) > local.az.dns_zone.min_length
      valid_name_unique = length(regexall(local.az.dns_zone.regex, local.az.dns_zone.name_unique)) > 0
    } : null
    eventgrid_domain = lookup(var.enabled, "eventgrid_domain", false) ? {
      valid_name        = length(regexall(local.az.eventgrid_domain.regex, local.az.eventgrid_domain.name)) > 0 && length(local.az.eventgrid_domain.name) > local.az.eventgrid_domain.min_length
      valid_name_unique = length(regexall(local.az.eventgrid_domain.regex, local.az.eventgrid_domain.name_unique)) > 0
    } : null
    eventgrid_domain_topic = lookup(var.enabled, "eventgrid_domain_topic", false) ? {
      valid_name        = length(regexall(local.az.eventgrid_domain_topic.regex, local.az.eventgrid_domain_topic.name)) > 0 && length(local.az.eventgrid_domain_topic.name) > local.az.eventgrid_domain_topic.min_length
      valid_name_unique = length(regexall(local.az.eventgrid_domain_topic.regex, local.az.eventgrid_domain_topic.name_unique)) > 0
    } : null
    eventgrid_event_subscription = lookup(var.enabled, "eventgrid_event_subscription", false) ? {
      valid_name        = length(regexall(local.az.eventgrid_event_subscription.regex, local.az.eventgrid_event_subscription.name)) > 0 && length(local.az.eventgrid_event_subscription.name) > local.az.eventgrid_event_subscription.min_length
      valid_name_unique = length(regexall(local.az.eventgrid_event_subscription.regex, local.az.eventgrid_event_subscription.name_unique)) > 0
    } : null
    eventgrid_topic = lookup(var.enabled, "eventgrid_topic", false) ? {
      valid_name        = length(regexall(local.az.eventgrid_topic.regex, local.az.eventgrid_topic.name)) > 0 && length(local.az.eventgrid_topic.name) > local.az.eventgrid_topic.min_length
      valid_name_unique = length(regexall(local.az.eventgrid_topic.regex, local.az.eventgrid_topic.name_unique)) > 0
    } : null
    eventhub = lookup(var.enabled, "eventhub", false) ? {
      valid_name        = length(regexall(local.az.eventhub.regex, local.az.eventhub.name)) > 0 && length(local.az.eventhub.name) > local.az.eventhub.min_length
      valid_name_unique = length(regexall(local.az.eventhub.regex, local.az.eventhub.name_unique)) > 0
    } : null
    eventhub_authorization_rule = lookup(var.enabled, "eventhub_authorization_rule", false) ? {
      valid_name        = length(regexall(local.az.eventhub_authorization_rule.regex, local.az.eventhub_authorization_rule.name)) > 0 && length(local.az.eventhub_authorization_rule.name) > local.az.eventhub_authorization_rule.min_length
      valid_name_unique = length(regexall(local.az.eventhub_authorization_rule.regex, local.az.eventhub_authorization_rule.name_unique)) > 0
    } : null
    eventhub_consumer_group = lookup(var.enabled, "eventhub_consumer_group", false) ? {
      valid_name        = length(regexall(local.az.eventhub_consumer_group.regex, local.az.eventhub_consumer_group.name)) > 0 && length(local.az.eventhub_consumer_group.name) > local.az.eventhub_consumer_group.min_length
      valid_name_unique = length(regexall(local.az.eventhub_consumer_group.regex, local.az.eventhub_consumer_group.name_unique)) > 0
    } : null
    eventhub_namespace = lookup(var.enabled, "eventhub_namespace", false) ? {
      valid_name        = length(regexall(local.az.eventhub_namespace.regex, local.az.eventhub_namespace.name)) > 0 && length(local.az.eventhub_namespace.name) > local.az.eventhub_namespace.min_length
      valid_name_unique = length(regexall(local.az.eventhub_namespace.regex, local.az.eventhub_namespace.name_unique)) > 0
    } : null
    eventhub_namespace_authorization_rule = lookup(var.enabled, "eventhub_namespace_authorization_rule", false) ? {
      valid_name        = length(regexall(local.az.eventhub_namespace_authorization_rule.regex, local.az.eventhub_namespace_authorization_rule.name)) > 0 && length(local.az.eventhub_namespace_authorization_rule.name) > local.az.eventhub_namespace_authorization_rule.min_length
      valid_name_unique = length(regexall(local.az.eventhub_namespace_authorization_rule.regex, local.az.eventhub_namespace_authorization_rule.name_unique)) > 0
    } : null
    eventhub_namespace_disaster_recovery_config = lookup(var.enabled, "eventhub_namespace_disaster_recovery_config", false) ? {
      valid_name        = length(regexall(local.az.eventhub_namespace_disaster_recovery_config.regex, local.az.eventhub_namespace_disaster_recovery_config.name)) > 0 && length(local.az.eventhub_namespace_disaster_recovery_config.name) > local.az.eventhub_namespace_disaster_recovery_config.min_length
      valid_name_unique = length(regexall(local.az.eventhub_namespace_disaster_recovery_config.regex, local.az.eventhub_namespace_disaster_recovery_config.name_unique)) > 0
    } : null
    express_route_circuit = lookup(var.enabled, "express_route_circuit", false) ? {
      valid_name        = length(regexall(local.az.express_route_circuit.regex, local.az.express_route_circuit.name)) > 0 && length(local.az.express_route_circuit.name) > local.az.express_route_circuit.min_length
      valid_name_unique = length(regexall(local.az.express_route_circuit.regex, local.az.express_route_circuit.name_unique)) > 0
    } : null
    express_route_gateway = lookup(var.enabled, "express_route_gateway", false) ? {
      valid_name        = length(regexall(local.az.express_route_gateway.regex, local.az.express_route_gateway.name)) > 0 && length(local.az.express_route_gateway.name) > local.az.express_route_gateway.min_length
      valid_name_unique = length(regexall(local.az.express_route_gateway.regex, local.az.express_route_gateway.name_unique)) > 0
    } : null
    firewall = lookup(var.enabled, "firewall", false) ? {
      valid_name        = length(regexall(local.az.firewall.regex, local.az.firewall.name)) > 0 && length(local.az.firewall.name) > local.az.firewall.min_length
      valid_name_unique = length(regexall(local.az.firewall.regex, local.az.firewall.name_unique)) > 0
    } : null
    firewall_application_rule_collection = lookup(var.enabled, "firewall_application_rule_collection", false) ? {
      valid_name        = length(regexall(local.az.firewall_application_rule_collection.regex, local.az.firewall_application_rule_collection.name)) > 0 && length(local.az.firewall_application_rule_collection.name) > local.az.firewall_application_rule_collection.min_length
      valid_name_unique = length(regexall(local.az.firewall_application_rule_collection.regex, local.az.firewall_application_rule_collection.name_unique)) > 0
    } : null
    firewall_ip_configuration = lookup(var.enabled, "firewall_ip_configuration", false) ? {
      valid_name        = length(regexall(local.az.firewall_ip_configuration.regex, local.az.firewall_ip_configuration.name)) > 0 && length(local.az.firewall_ip_configuration.name) > local.az.firewall_ip_configuration.min_length
      valid_name_unique = length(regexall(local.az.firewall_ip_configuration.regex, local.az.firewall_ip_configuration.name_unique)) > 0
    } : null
    firewall_nat_rule_collection = lookup(var.enabled, "firewall_nat_rule_collection", false) ? {
      valid_name        = length(regexall(local.az.firewall_nat_rule_collection.regex, local.az.firewall_nat_rule_collection.name)) > 0 && length(local.az.firewall_nat_rule_collection.name) > local.az.firewall_nat_rule_collection.min_length
      valid_name_unique = length(regexall(local.az.firewall_nat_rule_collection.regex, local.az.firewall_nat_rule_collection.name_unique)) > 0
    } : null
    firewall_network_rule_collection = lookup(var.enabled, "firewall_network_rule_collection", false) ? {
      valid_name        = length(regexall(local.az.firewall_network_rule_collection.regex, local.az.firewall_network_rule_collection.name)) > 0 && length(local.az.firewall_network_rule_collection.name) > local.az.firewall_network_rule_collection.min_length
      valid_name_unique = length(regexall(local.az.firewall_network_rule_collection.regex, local.az.firewall_network_rule_collection.name_unique)) > 0
    } : null
    firewall_policy = lookup(var.enabled, "firewall_policy", false) ? {
      valid_name        = length(regexall(local.az.firewall_policy.regex, local.az.firewall_policy.name)) > 0 && length(local.az.firewall_policy.name) > local.az.firewall_policy.min_length
      valid_name_unique = length(regexall(local.az.firewall_policy.regex, local.az.firewall_policy.name_unique)) > 0
    } : null
    firewall_policy_rule_collection_group = lookup(var.enabled, "firewall_policy_rule_collection_group", false) ? {
      valid_name        = length(regexall(local.az.firewall_policy_rule_collection_group.regex, local.az.firewall_policy_rule_collection_group.name)) > 0 && length(local.az.firewall_policy_rule_collection_group.name) > local.az.firewall_policy_rule_collection_group.min_length
      valid_name_unique = length(regexall(local.az.firewall_policy_rule_collection_group.regex, local.az.firewall_policy_rule_collection_group.name_unique)) > 0
    } : null
    frontdoor = lookup(var.enabled, "frontdoor", false) ? {
      valid_name        = length(regexall(local.az.frontdoor.regex, local.az.frontdoor.name)) > 0 && length(local.az.frontdoor.name) > local.az.frontdoor.min_length
      valid_name_unique = length(regexall(local.az.frontdoor.regex, local.az.frontdoor.name_unique)) > 0
    } : null
    frontdoor_firewall_policy = lookup(var.enabled, "frontdoor_firewall_policy", false) ? {
      valid_name        = length(regexall(local.az.frontdoor_firewall_policy.regex, local.az.frontdoor_firewall_policy.name)) > 0 && length(local.az.frontdoor_firewall_policy.name) > local.az.frontdoor_firewall_policy.min_length
      valid_name_unique = length(regexall(local.az.frontdoor_firewall_policy.regex, local.az.frontdoor_firewall_policy.name_unique)) > 0
    } : null
    function_app = lookup(var.enabled, "function_app", false) ? {
      valid_name        = length(regexall(local.az.function_app.regex, local.az.function_app.name)) > 0 && length(local.az.function_app.name) > local.az.function_app.min_length
      valid_name_unique = length(regexall(local.az.function_app.regex, local.az.function_app.name_unique)) > 0
    } : null
    hdinsight_hadoop_cluster = lookup(var.enabled, "hdinsight_hadoop_cluster", false) ? {
      valid_name        = length(regexall(local.az.hdinsight_hadoop_cluster.regex, local.az.hdinsight_hadoop_cluster.name)) > 0 && length(local.az.hdinsight_hadoop_cluster.name) > local.az.hdinsight_hadoop_cluster.min_length
      valid_name_unique = length(regexall(local.az.hdinsight_hadoop_cluster.regex, local.az.hdinsight_hadoop_cluster.name_unique)) > 0
    } : null
    hdinsight_hbase_cluster = lookup(var.enabled, "hdinsight_hbase_cluster", false) ? {
      valid_name        = length(regexall(local.az.hdinsight_hbase_cluster.regex, local.az.hdinsight_hbase_cluster.name)) > 0 && length(local.az.hdinsight_hbase_cluster.name) > local.az.hdinsight_hbase_cluster.min_length
      valid_name_unique = length(regexall(local.az.hdinsight_hbase_cluster.regex, local.az.hdinsight_hbase_cluster.name_unique)) > 0
    } : null
    hdinsight_interactive_query_cluster = lookup(var.enabled, "hdinsight_interactive_query_cluster", false) ? {
      valid_name        = length(regexall(local.az.hdinsight_interactive_query_cluster.regex, local.az.hdinsight_interactive_query_cluster.name)) > 0 && length(local.az.hdinsight_interactive_query_cluster.name) > local.az.hdinsight_interactive_query_cluster.min_length
      valid_name_unique = length(regexall(local.az.hdinsight_interactive_query_cluster.regex, local.az.hdinsight_interactive_query_cluster.name_unique)) > 0
    } : null
    hdinsight_kafka_cluster = lookup(var.enabled, "hdinsight_kafka_cluster", false) ? {
      valid_name        = length(regexall(local.az.hdinsight_kafka_cluster.regex, local.az.hdinsight_kafka_cluster.name)) > 0 && length(local.az.hdinsight_kafka_cluster.name) > local.az.hdinsight_kafka_cluster.min_length
      valid_name_unique = length(regexall(local.az.hdinsight_kafka_cluster.regex, local.az.hdinsight_kafka_cluster.name_unique)) > 0
    } : null
    hdinsight_ml_services_cluster = lookup(var.enabled, "hdinsight_ml_services_cluster", false) ? {
      valid_name        = length(regexall(local.az.hdinsight_ml_services_cluster.regex, local.az.hdinsight_ml_services_cluster.name)) > 0 && length(local.az.hdinsight_ml_services_cluster.name) > local.az.hdinsight_ml_services_cluster.min_length
      valid_name_unique = length(regexall(local.az.hdinsight_ml_services_cluster.regex, local.az.hdinsight_ml_services_cluster.name_unique)) > 0
    } : null
    hdinsight_rserver_cluster = lookup(var.enabled, "hdinsight_rserver_cluster", false) ? {
      valid_name        = length(regexall(local.az.hdinsight_rserver_cluster.regex, local.az.hdinsight_rserver_cluster.name)) > 0 && length(local.az.hdinsight_rserver_cluster.name) > local.az.hdinsight_rserver_cluster.min_length
      valid_name_unique = length(regexall(local.az.hdinsight_rserver_cluster.regex, local.az.hdinsight_rserver_cluster.name_unique)) > 0
    } : null
    hdinsight_spark_cluster = lookup(var.enabled, "hdinsight_spark_cluster", false) ? {
      valid_name        = length(regexall(local.az.hdinsight_spark_cluster.regex, local.az.hdinsight_spark_cluster.name)) > 0 && length(local.az.hdinsight_spark_cluster.name) > local.az.hdinsight_spark_cluster.min_length
      valid_name_unique = length(regexall(local.az.hdinsight_spark_cluster.regex, local.az.hdinsight_spark_cluster.name_unique)) > 0
    } : null
    hdinsight_storm_cluster = lookup(var.enabled, "hdinsight_storm_cluster", false) ? {
      valid_name        = length(regexall(local.az.hdinsight_storm_cluster.regex, local.az.hdinsight_storm_cluster.name)) > 0 && length(local.az.hdinsight_storm_cluster.name) > local.az.hdinsight_storm_cluster.min_length
      valid_name_unique = length(regexall(local.az.hdinsight_storm_cluster.regex, local.az.hdinsight_storm_cluster.name_unique)) > 0
    } : null
    image = lookup(var.enabled, "image", false) ? {
      valid_name        = length(regexall(local.az.image.regex, local.az.image.name)) > 0 && length(local.az.image.name) > local.az.image.min_length
      valid_name_unique = length(regexall(local.az.image.regex, local.az.image.name_unique)) > 0
    } : null
    iotcentral_application = lookup(var.enabled, "iotcentral_application", false) ? {
      valid_name        = length(regexall(local.az.iotcentral_application.regex, local.az.iotcentral_application.name)) > 0 && length(local.az.iotcentral_application.name) > local.az.iotcentral_application.min_length
      valid_name_unique = length(regexall(local.az.iotcentral_application.regex, local.az.iotcentral_application.name_unique)) > 0
    } : null
    iothub = lookup(var.enabled, "iothub", false) ? {
      valid_name        = length(regexall(local.az.iothub.regex, local.az.iothub.name)) > 0 && length(local.az.iothub.name) > local.az.iothub.min_length
      valid_name_unique = length(regexall(local.az.iothub.regex, local.az.iothub.name_unique)) > 0
    } : null
    iothub_consumer_group = lookup(var.enabled, "iothub_consumer_group", false) ? {
      valid_name        = length(regexall(local.az.iothub_consumer_group.regex, local.az.iothub_consumer_group.name)) > 0 && length(local.az.iothub_consumer_group.name) > local.az.iothub_consumer_group.min_length
      valid_name_unique = length(regexall(local.az.iothub_consumer_group.regex, local.az.iothub_consumer_group.name_unique)) > 0
    } : null
    iothub_dps = lookup(var.enabled, "iothub_dps", false) ? {
      valid_name        = length(regexall(local.az.iothub_dps.regex, local.az.iothub_dps.name)) > 0 && length(local.az.iothub_dps.name) > local.az.iothub_dps.min_length
      valid_name_unique = length(regexall(local.az.iothub_dps.regex, local.az.iothub_dps.name_unique)) > 0
    } : null
    iothub_dps_certificate = lookup(var.enabled, "iothub_dps_certificate", false) ? {
      valid_name        = length(regexall(local.az.iothub_dps_certificate.regex, local.az.iothub_dps_certificate.name)) > 0 && length(local.az.iothub_dps_certificate.name) > local.az.iothub_dps_certificate.min_length
      valid_name_unique = length(regexall(local.az.iothub_dps_certificate.regex, local.az.iothub_dps_certificate.name_unique)) > 0
    } : null
    key_vault = lookup(var.enabled, "key_vault", false) ? {
      valid_name        = length(regexall(local.az.key_vault.regex, local.az.key_vault.name)) > 0 && length(local.az.key_vault.name) > local.az.key_vault.min_length
      valid_name_unique = length(regexall(local.az.key_vault.regex, local.az.key_vault.name_unique)) > 0
    } : null
    key_vault_certificate = lookup(var.enabled, "key_vault_certificate", false) ? {
      valid_name        = length(regexall(local.az.key_vault_certificate.regex, local.az.key_vault_certificate.name)) > 0 && length(local.az.key_vault_certificate.name) > local.az.key_vault_certificate.min_length
      valid_name_unique = length(regexall(local.az.key_vault_certificate.regex, local.az.key_vault_certificate.name_unique)) > 0
    } : null
    key_vault_key = lookup(var.enabled, "key_vault_key", false) ? {
      valid_name        = length(regexall(local.az.key_vault_key.regex, local.az.key_vault_key.name)) > 0 && length(local.az.key_vault_key.name) > local.az.key_vault_key.min_length
      valid_name_unique = length(regexall(local.az.key_vault_key.regex, local.az.key_vault_key.name_unique)) > 0
    } : null
    key_vault_secret = lookup(var.enabled, "key_vault_secret", false) ? {
      valid_name        = length(regexall(local.az.key_vault_secret.regex, local.az.key_vault_secret.name)) > 0 && length(local.az.key_vault_secret.name) > local.az.key_vault_secret.min_length
      valid_name_unique = length(regexall(local.az.key_vault_secret.regex, local.az.key_vault_secret.name_unique)) > 0
    } : null
    kubernetes_cluster = lookup(var.enabled, "kubernetes_cluster", false) ? {
      valid_name        = length(regexall(local.az.kubernetes_cluster.regex, local.az.kubernetes_cluster.name)) > 0 && length(local.az.kubernetes_cluster.name) > local.az.kubernetes_cluster.min_length
      valid_name_unique = length(regexall(local.az.kubernetes_cluster.regex, local.az.kubernetes_cluster.name_unique)) > 0
    } : null
    kusto_cluster = lookup(var.enabled, "kusto_cluster", false) ? {
      valid_name        = length(regexall(local.az.kusto_cluster.regex, local.az.kusto_cluster.name)) > 0 && length(local.az.kusto_cluster.name) > local.az.kusto_cluster.min_length
      valid_name_unique = length(regexall(local.az.kusto_cluster.regex, local.az.kusto_cluster.name_unique)) > 0
    } : null
    kusto_database = lookup(var.enabled, "kusto_database", false) ? {
      valid_name        = length(regexall(local.az.kusto_database.regex, local.az.kusto_database.name)) > 0 && length(local.az.kusto_database.name) > local.az.kusto_database.min_length
      valid_name_unique = length(regexall(local.az.kusto_database.regex, local.az.kusto_database.name_unique)) > 0
    } : null
    kusto_eventhub_data_connection = lookup(var.enabled, "kusto_eventhub_data_connection", false) ? {
      valid_name        = length(regexall(local.az.kusto_eventhub_data_connection.regex, local.az.kusto_eventhub_data_connection.name)) > 0 && length(local.az.kusto_eventhub_data_connection.name) > local.az.kusto_eventhub_data_connection.min_length
      valid_name_unique = length(regexall(local.az.kusto_eventhub_data_connection.regex, local.az.kusto_eventhub_data_connection.name_unique)) > 0
    } : null
    lb = lookup(var.enabled, "lb", false) ? {
      valid_name        = length(regexall(local.az.lb.regex, local.az.lb.name)) > 0 && length(local.az.lb.name) > local.az.lb.min_length
      valid_name_unique = length(regexall(local.az.lb.regex, local.az.lb.name_unique)) > 0
    } : null
    lb_nat_rule = lookup(var.enabled, "lb_nat_rule", false) ? {
      valid_name        = length(regexall(local.az.lb_nat_rule.regex, local.az.lb_nat_rule.name)) > 0 && length(local.az.lb_nat_rule.name) > local.az.lb_nat_rule.min_length
      valid_name_unique = length(regexall(local.az.lb_nat_rule.regex, local.az.lb_nat_rule.name_unique)) > 0
    } : null
    linux_virtual_machine = lookup(var.enabled, "linux_virtual_machine", false) ? {
      valid_name        = length(regexall(local.az.linux_virtual_machine.regex, local.az.linux_virtual_machine.name)) > 0 && length(local.az.linux_virtual_machine.name) > local.az.linux_virtual_machine.min_length
      valid_name_unique = length(regexall(local.az.linux_virtual_machine.regex, local.az.linux_virtual_machine.name_unique)) > 0
    } : null
    linux_virtual_machine_scale_set = lookup(var.enabled, "linux_virtual_machine_scale_set", false) ? {
      valid_name        = length(regexall(local.az.linux_virtual_machine_scale_set.regex, local.az.linux_virtual_machine_scale_set.name)) > 0 && length(local.az.linux_virtual_machine_scale_set.name) > local.az.linux_virtual_machine_scale_set.min_length
      valid_name_unique = length(regexall(local.az.linux_virtual_machine_scale_set.regex, local.az.linux_virtual_machine_scale_set.name_unique)) > 0
    } : null
    load_test = lookup(var.enabled, "load_test", false) ? {
      valid_name        = length(regexall(local.az.load_test.regex, local.az.load_test.name)) > 0 && length(local.az.load_test.name) > local.az.load_test.min_length
      valid_name_unique = length(regexall(local.az.load_test.regex, local.az.load_test.name_unique)) > 0
    } : null
    local_network_gateway = lookup(var.enabled, "local_network_gateway", false) ? {
      valid_name        = length(regexall(local.az.local_network_gateway.regex, local.az.local_network_gateway.name)) > 0 && length(local.az.local_network_gateway.name) > local.az.local_network_gateway.min_length
      valid_name_unique = length(regexall(local.az.local_network_gateway.regex, local.az.local_network_gateway.name_unique)) > 0
    } : null
    log_analytics_workspace = lookup(var.enabled, "log_analytics_workspace", false) ? {
      valid_name        = length(regexall(local.az.log_analytics_workspace.regex, local.az.log_analytics_workspace.name)) > 0 && length(local.az.log_analytics_workspace.name) > local.az.log_analytics_workspace.min_length
      valid_name_unique = length(regexall(local.az.log_analytics_workspace.regex, local.az.log_analytics_workspace.name_unique)) > 0
    } : null
    logic_app_workflow = lookup(var.enabled, "logic_app_workflow", false) ? {
      valid_name        = length(regexall(local.az.logic_app_workflow.regex, local.az.logic_app_workflow.name)) > 0 && length(local.az.logic_app_workflow.name) > local.az.logic_app_workflow.min_length
      valid_name_unique = length(regexall(local.az.logic_app_workflow.regex, local.az.logic_app_workflow.name_unique)) > 0
    } : null
    machine_learning_workspace = lookup(var.enabled, "machine_learning_workspace", false) ? {
      valid_name        = length(regexall(local.az.machine_learning_workspace.regex, local.az.machine_learning_workspace.name)) > 0 && length(local.az.machine_learning_workspace.name) > local.az.machine_learning_workspace.min_length
      valid_name_unique = length(regexall(local.az.machine_learning_workspace.regex, local.az.machine_learning_workspace.name_unique)) > 0
    } : null
    managed_disk = lookup(var.enabled, "managed_disk", false) ? {
      valid_name        = length(regexall(local.az.managed_disk.regex, local.az.managed_disk.name)) > 0 && length(local.az.managed_disk.name) > local.az.managed_disk.min_length
      valid_name_unique = length(regexall(local.az.managed_disk.regex, local.az.managed_disk.name_unique)) > 0
    } : null
    management_lock = lookup(var.enabled, "management_lock", false) ? {
      valid_name        = length(regexall(local.az.management_lock.regex, local.az.management_lock.name)) > 0 && length(local.az.management_lock.name) > local.az.management_lock.min_length
      valid_name_unique = length(regexall(local.az.management_lock.regex, local.az.management_lock.name_unique)) > 0
    } : null
    maps_account = lookup(var.enabled, "maps_account", false) ? {
      valid_name        = length(regexall(local.az.maps_account.regex, local.az.maps_account.name)) > 0 && length(local.az.maps_account.name) > local.az.maps_account.min_length
      valid_name_unique = length(regexall(local.az.maps_account.regex, local.az.maps_account.name_unique)) > 0
    } : null
    mariadb_database = lookup(var.enabled, "mariadb_database", false) ? {
      valid_name        = length(regexall(local.az.mariadb_database.regex, local.az.mariadb_database.name)) > 0 && length(local.az.mariadb_database.name) > local.az.mariadb_database.min_length
      valid_name_unique = length(regexall(local.az.mariadb_database.regex, local.az.mariadb_database.name_unique)) > 0
    } : null
    mariadb_firewall_rule = lookup(var.enabled, "mariadb_firewall_rule", false) ? {
      valid_name        = length(regexall(local.az.mariadb_firewall_rule.regex, local.az.mariadb_firewall_rule.name)) > 0 && length(local.az.mariadb_firewall_rule.name) > local.az.mariadb_firewall_rule.min_length
      valid_name_unique = length(regexall(local.az.mariadb_firewall_rule.regex, local.az.mariadb_firewall_rule.name_unique)) > 0
    } : null
    mariadb_server = lookup(var.enabled, "mariadb_server", false) ? {
      valid_name        = length(regexall(local.az.mariadb_server.regex, local.az.mariadb_server.name)) > 0 && length(local.az.mariadb_server.name) > local.az.mariadb_server.min_length
      valid_name_unique = length(regexall(local.az.mariadb_server.regex, local.az.mariadb_server.name_unique)) > 0
    } : null
    mariadb_virtual_network_rule = lookup(var.enabled, "mariadb_virtual_network_rule", false) ? {
      valid_name        = length(regexall(local.az.mariadb_virtual_network_rule.regex, local.az.mariadb_virtual_network_rule.name)) > 0 && length(local.az.mariadb_virtual_network_rule.name) > local.az.mariadb_virtual_network_rule.min_length
      valid_name_unique = length(regexall(local.az.mariadb_virtual_network_rule.regex, local.az.mariadb_virtual_network_rule.name_unique)) > 0
    } : null
    monitor_action_group = lookup(var.enabled, "monitor_action_group", false) ? {
      valid_name        = length(regexall(local.az.monitor_action_group.regex, local.az.monitor_action_group.name)) > 0 && length(local.az.monitor_action_group.name) > local.az.monitor_action_group.min_length
      valid_name_unique = length(regexall(local.az.monitor_action_group.regex, local.az.monitor_action_group.name_unique)) > 0
    } : null
    monitor_autoscale_setting = lookup(var.enabled, "monitor_autoscale_setting", false) ? {
      valid_name        = length(regexall(local.az.monitor_autoscale_setting.regex, local.az.monitor_autoscale_setting.name)) > 0 && length(local.az.monitor_autoscale_setting.name) > local.az.monitor_autoscale_setting.min_length
      valid_name_unique = length(regexall(local.az.monitor_autoscale_setting.regex, local.az.monitor_autoscale_setting.name_unique)) > 0
    } : null
    monitor_diagnostic_setting = lookup(var.enabled, "monitor_diagnostic_setting", false) ? {
      valid_name        = length(regexall(local.az.monitor_diagnostic_setting.regex, local.az.monitor_diagnostic_setting.name)) > 0 && length(local.az.monitor_diagnostic_setting.name) > local.az.monitor_diagnostic_setting.min_length
      valid_name_unique = length(regexall(local.az.monitor_diagnostic_setting.regex, local.az.monitor_diagnostic_setting.name_unique)) > 0
    } : null
    monitor_scheduled_query_rules_alert = lookup(var.enabled, "monitor_scheduled_query_rules_alert", false) ? {
      valid_name        = length(regexall(local.az.monitor_scheduled_query_rules_alert.regex, local.az.monitor_scheduled_query_rules_alert.name)) > 0 && length(local.az.monitor_scheduled_query_rules_alert.name) > local.az.monitor_scheduled_query_rules_alert.min_length
      valid_name_unique = length(regexall(local.az.monitor_scheduled_query_rules_alert.regex, local.az.monitor_scheduled_query_rules_alert.name_unique)) > 0
    } : null
    mssql_database = lookup(var.enabled, "mssql_database", false) ? {
      valid_name        = length(regexall(local.az.mssql_database.regex, local.az.mssql_database.name)) > 0 && length(local.az.mssql_database.name) > local.az.mssql_database.min_length
      valid_name_unique = length(regexall(local.az.mssql_database.regex, local.az.mssql_database.name_unique)) > 0
    } : null
    mssql_elasticpool = lookup(var.enabled, "mssql_elasticpool", false) ? {
      valid_name        = length(regexall(local.az.mssql_elasticpool.regex, local.az.mssql_elasticpool.name)) > 0 && length(local.az.mssql_elasticpool.name) > local.az.mssql_elasticpool.min_length
      valid_name_unique = length(regexall(local.az.mssql_elasticpool.regex, local.az.mssql_elasticpool.name_unique)) > 0
    } : null
    mssql_managed_instance = lookup(var.enabled, "mssql_managed_instance", false) ? {
      valid_name        = length(regexall(local.az.mssql_managed_instance.regex, local.az.mssql_managed_instance.name)) > 0 && length(local.az.mssql_managed_instance.name) > local.az.mssql_managed_instance.min_length
      valid_name_unique = length(regexall(local.az.mssql_managed_instance.regex, local.az.mssql_managed_instance.name_unique)) > 0
    } : null
    mssql_server = lookup(var.enabled, "mssql_server", false) ? {
      valid_name        = length(regexall(local.az.mssql_server.regex, local.az.mssql_server.name)) > 0 && length(local.az.mssql_server.name) > local.az.mssql_server.min_length
      valid_name_unique = length(regexall(local.az.mssql_server.regex, local.az.mssql_server.name_unique)) > 0
    } : null
    mysql_database = lookup(var.enabled, "mysql_database", false) ? {
      valid_name        = length(regexall(local.az.mysql_database.regex, local.az.mysql_database.name)) > 0 && length(local.az.mysql_database.name) > local.az.mysql_database.min_length
      valid_name_unique = length(regexall(local.az.mysql_database.regex, local.az.mysql_database.name_unique)) > 0
    } : null
    mysql_firewall_rule = lookup(var.enabled, "mysql_firewall_rule", false) ? {
      valid_name        = length(regexall(local.az.mysql_firewall_rule.regex, local.az.mysql_firewall_rule.name)) > 0 && length(local.az.mysql_firewall_rule.name) > local.az.mysql_firewall_rule.min_length
      valid_name_unique = length(regexall(local.az.mysql_firewall_rule.regex, local.az.mysql_firewall_rule.name_unique)) > 0
    } : null
    mysql_server = lookup(var.enabled, "mysql_server", false) ? {
      valid_name        = length(regexall(local.az.mysql_server.regex, local.az.mysql_server.name)) > 0 && length(local.az.mysql_server.name) > local.az.mysql_server.min_length
      valid_name_unique = length(regexall(local.az.mysql_server.regex, local.az.mysql_server.name_unique)) > 0
    } : null
    mysql_virtual_network_rule = lookup(var.enabled, "mysql_virtual_network_rule", false) ? {
      valid_name        = length(regexall(local.az.mysql_virtual_network_rule.regex, local.az.mysql_virtual_network_rule.name)) > 0 && length(local.az.mysql_virtual_network_rule.name) > local.az.mysql_virtual_network_rule.min_length
      valid_name_unique = length(regexall(local.az.mysql_virtual_network_rule.regex, local.az.mysql_virtual_network_rule.name_unique)) > 0
    } : null
    nat_gateway = lookup(var.enabled, "nat_gateway", false) ? {
      valid_name        = length(regexall(local.az.nat_gateway.regex, local.az.nat_gateway.name)) > 0 && length(local.az.nat_gateway.name) > local.az.nat_gateway.min_length
      valid_name_unique = length(regexall(local.az.nat_gateway.regex, local.az.nat_gateway.name_unique)) > 0
    } : null
    network_ddos_protection_plan = lookup(var.enabled, "network_ddos_protection_plan", false) ? {
      valid_name        = length(regexall(local.az.network_ddos_protection_plan.regex, local.az.network_ddos_protection_plan.name)) > 0 && length(local.az.network_ddos_protection_plan.name) > local.az.network_ddos_protection_plan.min_length
      valid_name_unique = length(regexall(local.az.network_ddos_protection_plan.regex, local.az.network_ddos_protection_plan.name_unique)) > 0
    } : null
    network_interface = lookup(var.enabled, "network_interface", false) ? {
      valid_name        = length(regexall(local.az.network_interface.regex, local.az.network_interface.name)) > 0 && length(local.az.network_interface.name) > local.az.network_interface.min_length
      valid_name_unique = length(regexall(local.az.network_interface.regex, local.az.network_interface.name_unique)) > 0
    } : null
    network_security_group = lookup(var.enabled, "network_security_group", false) ? {
      valid_name        = length(regexall(local.az.network_security_group.regex, local.az.network_security_group.name)) > 0 && length(local.az.network_security_group.name) > local.az.network_security_group.min_length
      valid_name_unique = length(regexall(local.az.network_security_group.regex, local.az.network_security_group.name_unique)) > 0
    } : null
    network_security_group_rule = lookup(var.enabled, "network_security_group_rule", false) ? {
      valid_name        = length(regexall(local.az.network_security_group_rule.regex, local.az.network_security_group_rule.name)) > 0 && length(local.az.network_security_group_rule.name) > local.az.network_security_group_rule.min_length
      valid_name_unique = length(regexall(local.az.network_security_group_rule.regex, local.az.network_security_group_rule.name_unique)) > 0
    } : null
    network_security_rule = lookup(var.enabled, "network_security_rule", false) ? {
      valid_name        = length(regexall(local.az.network_security_rule.regex, local.az.network_security_rule.name)) > 0 && length(local.az.network_security_rule.name) > local.az.network_security_rule.min_length
      valid_name_unique = length(regexall(local.az.network_security_rule.regex, local.az.network_security_rule.name_unique)) > 0
    } : null
    network_watcher = lookup(var.enabled, "network_watcher", false) ? {
      valid_name        = length(regexall(local.az.network_watcher.regex, local.az.network_watcher.name)) > 0 && length(local.az.network_watcher.name) > local.az.network_watcher.min_length
      valid_name_unique = length(regexall(local.az.network_watcher.regex, local.az.network_watcher.name_unique)) > 0
    } : null
    notification_hub = lookup(var.enabled, "notification_hub", false) ? {
      valid_name        = length(regexall(local.az.notification_hub.regex, local.az.notification_hub.name)) > 0 && length(local.az.notification_hub.name) > local.az.notification_hub.min_length
      valid_name_unique = length(regexall(local.az.notification_hub.regex, local.az.notification_hub.name_unique)) > 0
    } : null
    notification_hub_authorization_rule = lookup(var.enabled, "notification_hub_authorization_rule", false) ? {
      valid_name        = length(regexall(local.az.notification_hub_authorization_rule.regex, local.az.notification_hub_authorization_rule.name)) > 0 && length(local.az.notification_hub_authorization_rule.name) > local.az.notification_hub_authorization_rule.min_length
      valid_name_unique = length(regexall(local.az.notification_hub_authorization_rule.regex, local.az.notification_hub_authorization_rule.name_unique)) > 0
    } : null
    notification_hub_namespace = lookup(var.enabled, "notification_hub_namespace", false) ? {
      valid_name        = length(regexall(local.az.notification_hub_namespace.regex, local.az.notification_hub_namespace.name)) > 0 && length(local.az.notification_hub_namespace.name) > local.az.notification_hub_namespace.min_length
      valid_name_unique = length(regexall(local.az.notification_hub_namespace.regex, local.az.notification_hub_namespace.name_unique)) > 0
    } : null
    point_to_site_vpn_gateway = lookup(var.enabled, "point_to_site_vpn_gateway", false) ? {
      valid_name        = length(regexall(local.az.point_to_site_vpn_gateway.regex, local.az.point_to_site_vpn_gateway.name)) > 0 && length(local.az.point_to_site_vpn_gateway.name) > local.az.point_to_site_vpn_gateway.min_length
      valid_name_unique = length(regexall(local.az.point_to_site_vpn_gateway.regex, local.az.point_to_site_vpn_gateway.name_unique)) > 0
    } : null
    postgresql_database = lookup(var.enabled, "postgresql_database", false) ? {
      valid_name        = length(regexall(local.az.postgresql_database.regex, local.az.postgresql_database.name)) > 0 && length(local.az.postgresql_database.name) > local.az.postgresql_database.min_length
      valid_name_unique = length(regexall(local.az.postgresql_database.regex, local.az.postgresql_database.name_unique)) > 0
    } : null
    postgresql_firewall_rule = lookup(var.enabled, "postgresql_firewall_rule", false) ? {
      valid_name        = length(regexall(local.az.postgresql_firewall_rule.regex, local.az.postgresql_firewall_rule.name)) > 0 && length(local.az.postgresql_firewall_rule.name) > local.az.postgresql_firewall_rule.min_length
      valid_name_unique = length(regexall(local.az.postgresql_firewall_rule.regex, local.az.postgresql_firewall_rule.name_unique)) > 0
    } : null
    postgresql_flexible_server = lookup(var.enabled, "postgresql_flexible_server", false) ? {
      valid_name        = length(regexall(local.az.postgresql_flexible_server.regex, local.az.postgresql_flexible_server.name)) > 0 && length(local.az.postgresql_flexible_server.name) > local.az.postgresql_flexible_server.min_length
      valid_name_unique = length(regexall(local.az.postgresql_flexible_server.regex, local.az.postgresql_flexible_server.name_unique)) > 0
    } : null
    postgresql_flexible_server_firewall_rule = lookup(var.enabled, "postgresql_flexible_server_firewall_rule", false) ? {
      valid_name        = length(regexall(local.az.postgresql_flexible_server_firewall_rule.regex, local.az.postgresql_flexible_server_firewall_rule.name)) > 0 && length(local.az.postgresql_flexible_server_firewall_rule.name) > local.az.postgresql_flexible_server_firewall_rule.min_length
      valid_name_unique = length(regexall(local.az.postgresql_flexible_server_firewall_rule.regex, local.az.postgresql_flexible_server_firewall_rule.name_unique)) > 0
    } : null
    postgresql_server = lookup(var.enabled, "postgresql_server", false) ? {
      valid_name        = length(regexall(local.az.postgresql_server.regex, local.az.postgresql_server.name)) > 0 && length(local.az.postgresql_server.name) > local.az.postgresql_server.min_length
      valid_name_unique = length(regexall(local.az.postgresql_server.regex, local.az.postgresql_server.name_unique)) > 0
    } : null
    postgresql_virtual_network_rule = lookup(var.enabled, "postgresql_virtual_network_rule", false) ? {
      valid_name        = length(regexall(local.az.postgresql_virtual_network_rule.regex, local.az.postgresql_virtual_network_rule.name)) > 0 && length(local.az.postgresql_virtual_network_rule.name) > local.az.postgresql_virtual_network_rule.min_length
      valid_name_unique = length(regexall(local.az.postgresql_virtual_network_rule.regex, local.az.postgresql_virtual_network_rule.name_unique)) > 0
    } : null
    powerbi_embedded = lookup(var.enabled, "powerbi_embedded", false) ? {
      valid_name        = length(regexall(local.az.powerbi_embedded.regex, local.az.powerbi_embedded.name)) > 0 && length(local.az.powerbi_embedded.name) > local.az.powerbi_embedded.min_length
      valid_name_unique = length(regexall(local.az.powerbi_embedded.regex, local.az.powerbi_embedded.name_unique)) > 0
    } : null
    private_dns_a_record = lookup(var.enabled, "private_dns_a_record", false) ? {
      valid_name        = length(regexall(local.az.private_dns_a_record.regex, local.az.private_dns_a_record.name)) > 0 && length(local.az.private_dns_a_record.name) > local.az.private_dns_a_record.min_length
      valid_name_unique = length(regexall(local.az.private_dns_a_record.regex, local.az.private_dns_a_record.name_unique)) > 0
    } : null
    private_dns_aaaa_record = lookup(var.enabled, "private_dns_aaaa_record", false) ? {
      valid_name        = length(regexall(local.az.private_dns_aaaa_record.regex, local.az.private_dns_aaaa_record.name)) > 0 && length(local.az.private_dns_aaaa_record.name) > local.az.private_dns_aaaa_record.min_length
      valid_name_unique = length(regexall(local.az.private_dns_aaaa_record.regex, local.az.private_dns_aaaa_record.name_unique)) > 0
    } : null
    private_dns_cname_record = lookup(var.enabled, "private_dns_cname_record", false) ? {
      valid_name        = length(regexall(local.az.private_dns_cname_record.regex, local.az.private_dns_cname_record.name)) > 0 && length(local.az.private_dns_cname_record.name) > local.az.private_dns_cname_record.min_length
      valid_name_unique = length(regexall(local.az.private_dns_cname_record.regex, local.az.private_dns_cname_record.name_unique)) > 0
    } : null
    private_dns_mx_record = lookup(var.enabled, "private_dns_mx_record", false) ? {
      valid_name        = length(regexall(local.az.private_dns_mx_record.regex, local.az.private_dns_mx_record.name)) > 0 && length(local.az.private_dns_mx_record.name) > local.az.private_dns_mx_record.min_length
      valid_name_unique = length(regexall(local.az.private_dns_mx_record.regex, local.az.private_dns_mx_record.name_unique)) > 0
    } : null
    private_dns_ptr_record = lookup(var.enabled, "private_dns_ptr_record", false) ? {
      valid_name        = length(regexall(local.az.private_dns_ptr_record.regex, local.az.private_dns_ptr_record.name)) > 0 && length(local.az.private_dns_ptr_record.name) > local.az.private_dns_ptr_record.min_length
      valid_name_unique = length(regexall(local.az.private_dns_ptr_record.regex, local.az.private_dns_ptr_record.name_unique)) > 0
    } : null
    private_dns_srv_record = lookup(var.enabled, "private_dns_srv_record", false) ? {
      valid_name        = length(regexall(local.az.private_dns_srv_record.regex, local.az.private_dns_srv_record.name)) > 0 && length(local.az.private_dns_srv_record.name) > local.az.private_dns_srv_record.min_length
      valid_name_unique = length(regexall(local.az.private_dns_srv_record.regex, local.az.private_dns_srv_record.name_unique)) > 0
    } : null
    private_dns_txt_record = lookup(var.enabled, "private_dns_txt_record", false) ? {
      valid_name        = length(regexall(local.az.private_dns_txt_record.regex, local.az.private_dns_txt_record.name)) > 0 && length(local.az.private_dns_txt_record.name) > local.az.private_dns_txt_record.min_length
      valid_name_unique = length(regexall(local.az.private_dns_txt_record.regex, local.az.private_dns_txt_record.name_unique)) > 0
    } : null
    private_dns_zone = lookup(var.enabled, "private_dns_zone", false) ? {
      valid_name        = length(regexall(local.az.private_dns_zone.regex, local.az.private_dns_zone.name)) > 0 && length(local.az.private_dns_zone.name) > local.az.private_dns_zone.min_length
      valid_name_unique = length(regexall(local.az.private_dns_zone.regex, local.az.private_dns_zone.name_unique)) > 0
    } : null
    private_dns_zone_group = lookup(var.enabled, "private_dns_zone_group", false) ? {
      valid_name        = length(regexall(local.az.private_dns_zone_group.regex, local.az.private_dns_zone_group.name)) > 0 && length(local.az.private_dns_zone_group.name) > local.az.private_dns_zone_group.min_length
      valid_name_unique = length(regexall(local.az.private_dns_zone_group.regex, local.az.private_dns_zone_group.name_unique)) > 0
    } : null
    private_endpoint = lookup(var.enabled, "private_endpoint", false) ? {
      valid_name        = length(regexall(local.az.private_endpoint.regex, local.az.private_endpoint.name)) > 0 && length(local.az.private_endpoint.name) > local.az.private_endpoint.min_length
      valid_name_unique = length(regexall(local.az.private_endpoint.regex, local.az.private_endpoint.name_unique)) > 0
    } : null
    private_link_service = lookup(var.enabled, "private_link_service", false) ? {
      valid_name        = length(regexall(local.az.private_link_service.regex, local.az.private_link_service.name)) > 0 && length(local.az.private_link_service.name) > local.az.private_link_service.min_length
      valid_name_unique = length(regexall(local.az.private_link_service.regex, local.az.private_link_service.name_unique)) > 0
    } : null
    private_service_connection = lookup(var.enabled, "private_service_connection", false) ? {
      valid_name        = length(regexall(local.az.private_service_connection.regex, local.az.private_service_connection.name)) > 0 && length(local.az.private_service_connection.name) > local.az.private_service_connection.min_length
      valid_name_unique = length(regexall(local.az.private_service_connection.regex, local.az.private_service_connection.name_unique)) > 0
    } : null
    proximity_placement_group = lookup(var.enabled, "proximity_placement_group", false) ? {
      valid_name        = length(regexall(local.az.proximity_placement_group.regex, local.az.proximity_placement_group.name)) > 0 && length(local.az.proximity_placement_group.name) > local.az.proximity_placement_group.min_length
      valid_name_unique = length(regexall(local.az.proximity_placement_group.regex, local.az.proximity_placement_group.name_unique)) > 0
    } : null
    public_ip = lookup(var.enabled, "public_ip", false) ? {
      valid_name        = length(regexall(local.az.public_ip.regex, local.az.public_ip.name)) > 0 && length(local.az.public_ip.name) > local.az.public_ip.min_length
      valid_name_unique = length(regexall(local.az.public_ip.regex, local.az.public_ip.name_unique)) > 0
    } : null
    public_ip_prefix = lookup(var.enabled, "public_ip_prefix", false) ? {
      valid_name        = length(regexall(local.az.public_ip_prefix.regex, local.az.public_ip_prefix.name)) > 0 && length(local.az.public_ip_prefix.name) > local.az.public_ip_prefix.min_length
      valid_name_unique = length(regexall(local.az.public_ip_prefix.regex, local.az.public_ip_prefix.name_unique)) > 0
    } : null
    recovery_services_vault = lookup(var.enabled, "recovery_services_vault", false) ? {
      valid_name        = length(regexall(local.az.recovery_services_vault.regex, local.az.recovery_services_vault.name)) > 0 && length(local.az.recovery_services_vault.name) > local.az.recovery_services_vault.min_length
      valid_name_unique = length(regexall(local.az.recovery_services_vault.regex, local.az.recovery_services_vault.name_unique)) > 0
    } : null
    redis_cache = lookup(var.enabled, "redis_cache", false) ? {
      valid_name        = length(regexall(local.az.redis_cache.regex, local.az.redis_cache.name)) > 0 && length(local.az.redis_cache.name) > local.az.redis_cache.min_length
      valid_name_unique = length(regexall(local.az.redis_cache.regex, local.az.redis_cache.name_unique)) > 0
    } : null
    redis_firewall_rule = lookup(var.enabled, "redis_firewall_rule", false) ? {
      valid_name        = length(regexall(local.az.redis_firewall_rule.regex, local.az.redis_firewall_rule.name)) > 0 && length(local.az.redis_firewall_rule.name) > local.az.redis_firewall_rule.min_length
      valid_name_unique = length(regexall(local.az.redis_firewall_rule.regex, local.az.redis_firewall_rule.name_unique)) > 0
    } : null
    relay_hybrid_connection = lookup(var.enabled, "relay_hybrid_connection", false) ? {
      valid_name        = length(regexall(local.az.relay_hybrid_connection.regex, local.az.relay_hybrid_connection.name)) > 0 && length(local.az.relay_hybrid_connection.name) > local.az.relay_hybrid_connection.min_length
      valid_name_unique = length(regexall(local.az.relay_hybrid_connection.regex, local.az.relay_hybrid_connection.name_unique)) > 0
    } : null
    relay_namespace = lookup(var.enabled, "relay_namespace", false) ? {
      valid_name        = length(regexall(local.az.relay_namespace.regex, local.az.relay_namespace.name)) > 0 && length(local.az.relay_namespace.name) > local.az.relay_namespace.min_length
      valid_name_unique = length(regexall(local.az.relay_namespace.regex, local.az.relay_namespace.name_unique)) > 0
    } : null
    resource_group = lookup(var.enabled, "resource_group", false) ? {
      valid_name        = length(regexall(local.az.resource_group.regex, local.az.resource_group.name)) > 0 && length(local.az.resource_group.name) > local.az.resource_group.min_length
      valid_name_unique = length(regexall(local.az.resource_group.regex, local.az.resource_group.name_unique)) > 0
    } : null
    role_assignment = lookup(var.enabled, "role_assignment", false) ? {
      valid_name        = length(regexall(local.az.role_assignment.regex, local.az.role_assignment.name)) > 0 && length(local.az.role_assignment.name) > local.az.role_assignment.min_length
      valid_name_unique = length(regexall(local.az.role_assignment.regex, local.az.role_assignment.name_unique)) > 0
    } : null
    role_definition = lookup(var.enabled, "role_definition", false) ? {
      valid_name        = length(regexall(local.az.role_definition.regex, local.az.role_definition.name)) > 0 && length(local.az.role_definition.name) > local.az.role_definition.min_length
      valid_name_unique = length(regexall(local.az.role_definition.regex, local.az.role_definition.name_unique)) > 0
    } : null
    route = lookup(var.enabled, "route", false) ? {
      valid_name        = length(regexall(local.az.route.regex, local.az.route.name)) > 0 && length(local.az.route.name) > local.az.route.min_length
      valid_name_unique = length(regexall(local.az.route.regex, local.az.route.name_unique)) > 0
    } : null
    route_table = lookup(var.enabled, "route_table", false) ? {
      valid_name        = length(regexall(local.az.route_table.regex, local.az.route_table.name)) > 0 && length(local.az.route_table.name) > local.az.route_table.min_length
      valid_name_unique = length(regexall(local.az.route_table.regex, local.az.route_table.name_unique)) > 0
    } : null
    search_service = lookup(var.enabled, "search_service", false) ? {
      valid_name        = length(regexall(local.az.search_service.regex, local.az.search_service.name)) > 0 && length(local.az.search_service.name) > local.az.search_service.min_length
      valid_name_unique = length(regexall(local.az.search_service.regex, local.az.search_service.name_unique)) > 0
    } : null
    service_fabric_cluster = lookup(var.enabled, "service_fabric_cluster", false) ? {
      valid_name        = length(regexall(local.az.service_fabric_cluster.regex, local.az.service_fabric_cluster.name)) > 0 && length(local.az.service_fabric_cluster.name) > local.az.service_fabric_cluster.min_length
      valid_name_unique = length(regexall(local.az.service_fabric_cluster.regex, local.az.service_fabric_cluster.name_unique)) > 0
    } : null
    servicebus_namespace = lookup(var.enabled, "servicebus_namespace", false) ? {
      valid_name        = length(regexall(local.az.servicebus_namespace.regex, local.az.servicebus_namespace.name)) > 0 && length(local.az.servicebus_namespace.name) > local.az.servicebus_namespace.min_length
      valid_name_unique = length(regexall(local.az.servicebus_namespace.regex, local.az.servicebus_namespace.name_unique)) > 0
    } : null
    servicebus_namespace_authorization_rule = lookup(var.enabled, "servicebus_namespace_authorization_rule", false) ? {
      valid_name        = length(regexall(local.az.servicebus_namespace_authorization_rule.regex, local.az.servicebus_namespace_authorization_rule.name)) > 0 && length(local.az.servicebus_namespace_authorization_rule.name) > local.az.servicebus_namespace_authorization_rule.min_length
      valid_name_unique = length(regexall(local.az.servicebus_namespace_authorization_rule.regex, local.az.servicebus_namespace_authorization_rule.name_unique)) > 0
    } : null
    servicebus_queue = lookup(var.enabled, "servicebus_queue", false) ? {
      valid_name        = length(regexall(local.az.servicebus_queue.regex, local.az.servicebus_queue.name)) > 0 && length(local.az.servicebus_queue.name) > local.az.servicebus_queue.min_length
      valid_name_unique = length(regexall(local.az.servicebus_queue.regex, local.az.servicebus_queue.name_unique)) > 0
    } : null
    servicebus_queue_authorization_rule = lookup(var.enabled, "servicebus_queue_authorization_rule", false) ? {
      valid_name        = length(regexall(local.az.servicebus_queue_authorization_rule.regex, local.az.servicebus_queue_authorization_rule.name)) > 0 && length(local.az.servicebus_queue_authorization_rule.name) > local.az.servicebus_queue_authorization_rule.min_length
      valid_name_unique = length(regexall(local.az.servicebus_queue_authorization_rule.regex, local.az.servicebus_queue_authorization_rule.name_unique)) > 0
    } : null
    servicebus_subscription = lookup(var.enabled, "servicebus_subscription", false) ? {
      valid_name        = length(regexall(local.az.servicebus_subscription.regex, local.az.servicebus_subscription.name)) > 0 && length(local.az.servicebus_subscription.name) > local.az.servicebus_subscription.min_length
      valid_name_unique = length(regexall(local.az.servicebus_subscription.regex, local.az.servicebus_subscription.name_unique)) > 0
    } : null
    servicebus_subscription_rule = lookup(var.enabled, "servicebus_subscription_rule", false) ? {
      valid_name        = length(regexall(local.az.servicebus_subscription_rule.regex, local.az.servicebus_subscription_rule.name)) > 0 && length(local.az.servicebus_subscription_rule.name) > local.az.servicebus_subscription_rule.min_length
      valid_name_unique = length(regexall(local.az.servicebus_subscription_rule.regex, local.az.servicebus_subscription_rule.name_unique)) > 0
    } : null
    servicebus_topic = lookup(var.enabled, "servicebus_topic", false) ? {
      valid_name        = length(regexall(local.az.servicebus_topic.regex, local.az.servicebus_topic.name)) > 0 && length(local.az.servicebus_topic.name) > local.az.servicebus_topic.min_length
      valid_name_unique = length(regexall(local.az.servicebus_topic.regex, local.az.servicebus_topic.name_unique)) > 0
    } : null
    servicebus_topic_authorization_rule = lookup(var.enabled, "servicebus_topic_authorization_rule", false) ? {
      valid_name        = length(regexall(local.az.servicebus_topic_authorization_rule.regex, local.az.servicebus_topic_authorization_rule.name)) > 0 && length(local.az.servicebus_topic_authorization_rule.name) > local.az.servicebus_topic_authorization_rule.min_length
      valid_name_unique = length(regexall(local.az.servicebus_topic_authorization_rule.regex, local.az.servicebus_topic_authorization_rule.name_unique)) > 0
    } : null
    shared_image = lookup(var.enabled, "shared_image", false) ? {
      valid_name        = length(regexall(local.az.shared_image.regex, local.az.shared_image.name)) > 0 && length(local.az.shared_image.name) > local.az.shared_image.min_length
      valid_name_unique = length(regexall(local.az.shared_image.regex, local.az.shared_image.name_unique)) > 0
    } : null
    shared_image_gallery = lookup(var.enabled, "shared_image_gallery", false) ? {
      valid_name        = length(regexall(local.az.shared_image_gallery.regex, local.az.shared_image_gallery.name)) > 0 && length(local.az.shared_image_gallery.name) > local.az.shared_image_gallery.min_length
      valid_name_unique = length(regexall(local.az.shared_image_gallery.regex, local.az.shared_image_gallery.name_unique)) > 0
    } : null
    signalr_service = lookup(var.enabled, "signalr_service", false) ? {
      valid_name        = length(regexall(local.az.signalr_service.regex, local.az.signalr_service.name)) > 0 && length(local.az.signalr_service.name) > local.az.signalr_service.min_length
      valid_name_unique = length(regexall(local.az.signalr_service.regex, local.az.signalr_service.name_unique)) > 0
    } : null
    snapshots = lookup(var.enabled, "snapshots", false) ? {
      valid_name        = length(regexall(local.az.snapshots.regex, local.az.snapshots.name)) > 0 && length(local.az.snapshots.name) > local.az.snapshots.min_length
      valid_name_unique = length(regexall(local.az.snapshots.regex, local.az.snapshots.name_unique)) > 0
    } : null
    sql_elasticpool = lookup(var.enabled, "sql_elasticpool", false) ? {
      valid_name        = length(regexall(local.az.sql_elasticpool.regex, local.az.sql_elasticpool.name)) > 0 && length(local.az.sql_elasticpool.name) > local.az.sql_elasticpool.min_length
      valid_name_unique = length(regexall(local.az.sql_elasticpool.regex, local.az.sql_elasticpool.name_unique)) > 0
    } : null
    sql_failover_group = lookup(var.enabled, "sql_failover_group", false) ? {
      valid_name        = length(regexall(local.az.sql_failover_group.regex, local.az.sql_failover_group.name)) > 0 && length(local.az.sql_failover_group.name) > local.az.sql_failover_group.min_length
      valid_name_unique = length(regexall(local.az.sql_failover_group.regex, local.az.sql_failover_group.name_unique)) > 0
    } : null
    sql_firewall_rule = lookup(var.enabled, "sql_firewall_rule", false) ? {
      valid_name        = length(regexall(local.az.sql_firewall_rule.regex, local.az.sql_firewall_rule.name)) > 0 && length(local.az.sql_firewall_rule.name) > local.az.sql_firewall_rule.min_length
      valid_name_unique = length(regexall(local.az.sql_firewall_rule.regex, local.az.sql_firewall_rule.name_unique)) > 0
    } : null
    sql_server = lookup(var.enabled, "sql_server", false) ? {
      valid_name        = length(regexall(local.az.sql_server.regex, local.az.sql_server.name)) > 0 && length(local.az.sql_server.name) > local.az.sql_server.min_length
      valid_name_unique = length(regexall(local.az.sql_server.regex, local.az.sql_server.name_unique)) > 0
    } : null
    static_web_app = lookup(var.enabled, "static_web_app", false) ? {
      valid_name        = length(regexall(local.az.static_web_app.regex, local.az.static_web_app.name)) > 0 && length(local.az.static_web_app.name) > local.az.static_web_app.min_length
      valid_name_unique = length(regexall(local.az.static_web_app.regex, local.az.static_web_app.name_unique)) > 0
    } : null
    storage_account = lookup(var.enabled, "storage_account", false) ? {
      valid_name        = length(regexall(local.az.storage_account.regex, local.az.storage_account.name)) > 0 && length(local.az.storage_account.name) > local.az.storage_account.min_length
      valid_name_unique = length(regexall(local.az.storage_account.regex, local.az.storage_account.name_unique)) > 0
    } : null
    storage_blob = lookup(var.enabled, "storage_blob", false) ? {
      valid_name        = length(regexall(local.az.storage_blob.regex, local.az.storage_blob.name)) > 0 && length(local.az.storage_blob.name) > local.az.storage_blob.min_length
      valid_name_unique = length(regexall(local.az.storage_blob.regex, local.az.storage_blob.name_unique)) > 0
    } : null
    storage_container = lookup(var.enabled, "storage_container", false) ? {
      valid_name        = length(regexall(local.az.storage_container.regex, local.az.storage_container.name)) > 0 && length(local.az.storage_container.name) > local.az.storage_container.min_length
      valid_name_unique = length(regexall(local.az.storage_container.regex, local.az.storage_container.name_unique)) > 0
    } : null
    storage_data_lake_gen2_filesystem = lookup(var.enabled, "storage_data_lake_gen2_filesystem", false) ? {
      valid_name        = length(regexall(local.az.storage_data_lake_gen2_filesystem.regex, local.az.storage_data_lake_gen2_filesystem.name)) > 0 && length(local.az.storage_data_lake_gen2_filesystem.name) > local.az.storage_data_lake_gen2_filesystem.min_length
      valid_name_unique = length(regexall(local.az.storage_data_lake_gen2_filesystem.regex, local.az.storage_data_lake_gen2_filesystem.name_unique)) > 0
    } : null
    storage_queue = lookup(var.enabled, "storage_queue", false) ? {
      valid_name        = length(regexall(local.az.storage_queue.regex, local.az.storage_queue.name)) > 0 && length(local.az.storage_queue.name) > local.az.storage_queue.min_length
      valid_name_unique = length(regexall(local.az.storage_queue.regex, local.az.storage_queue.name_unique)) > 0
    } : null
    storage_share = lookup(var.enabled, "storage_share", false) ? {
      valid_name        = length(regexall(local.az.storage_share.regex, local.az.storage_share.name)) > 0 && length(local.az.storage_share.name) > local.az.storage_share.min_length
      valid_name_unique = length(regexall(local.az.storage_share.regex, local.az.storage_share.name_unique)) > 0
    } : null
    storage_share_directory = lookup(var.enabled, "storage_share_directory", false) ? {
      valid_name        = length(regexall(local.az.storage_share_directory.regex, local.az.storage_share_directory.name)) > 0 && length(local.az.storage_share_directory.name) > local.az.storage_share_directory.min_length
      valid_name_unique = length(regexall(local.az.storage_share_directory.regex, local.az.storage_share_directory.name_unique)) > 0
    } : null
    storage_table = lookup(var.enabled, "storage_table", false) ? {
      valid_name        = length(regexall(local.az.storage_table.regex, local.az.storage_table.name)) > 0 && length(local.az.storage_table.name) > local.az.storage_table.min_length
      valid_name_unique = length(regexall(local.az.storage_table.regex, local.az.storage_table.name_unique)) > 0
    } : null
    stream_analytics_function_javascript_udf = lookup(var.enabled, "stream_analytics_function_javascript_udf", false) ? {
      valid_name        = length(regexall(local.az.stream_analytics_function_javascript_udf.regex, local.az.stream_analytics_function_javascript_udf.name)) > 0 && length(local.az.stream_analytics_function_javascript_udf.name) > local.az.stream_analytics_function_javascript_udf.min_length
      valid_name_unique = length(regexall(local.az.stream_analytics_function_javascript_udf.regex, local.az.stream_analytics_function_javascript_udf.name_unique)) > 0
    } : null
    stream_analytics_job = lookup(var.enabled, "stream_analytics_job", false) ? {
      valid_name        = length(regexall(local.az.stream_analytics_job.regex, local.az.stream_analytics_job.name)) > 0 && length(local.az.stream_analytics_job.name) > local.az.stream_analytics_job.min_length
      valid_name_unique = length(regexall(local.az.stream_analytics_job.regex, local.az.stream_analytics_job.name_unique)) > 0
    } : null
    stream_analytics_output_blob = lookup(var.enabled, "stream_analytics_output_blob", false) ? {
      valid_name        = length(regexall(local.az.stream_analytics_output_blob.regex, local.az.stream_analytics_output_blob.name)) > 0 && length(local.az.stream_analytics_output_blob.name) > local.az.stream_analytics_output_blob.min_length
      valid_name_unique = length(regexall(local.az.stream_analytics_output_blob.regex, local.az.stream_analytics_output_blob.name_unique)) > 0
    } : null
    stream_analytics_output_eventhub = lookup(var.enabled, "stream_analytics_output_eventhub", false) ? {
      valid_name        = length(regexall(local.az.stream_analytics_output_eventhub.regex, local.az.stream_analytics_output_eventhub.name)) > 0 && length(local.az.stream_analytics_output_eventhub.name) > local.az.stream_analytics_output_eventhub.min_length
      valid_name_unique = length(regexall(local.az.stream_analytics_output_eventhub.regex, local.az.stream_analytics_output_eventhub.name_unique)) > 0
    } : null
    stream_analytics_output_mssql = lookup(var.enabled, "stream_analytics_output_mssql", false) ? {
      valid_name        = length(regexall(local.az.stream_analytics_output_mssql.regex, local.az.stream_analytics_output_mssql.name)) > 0 && length(local.az.stream_analytics_output_mssql.name) > local.az.stream_analytics_output_mssql.min_length
      valid_name_unique = length(regexall(local.az.stream_analytics_output_mssql.regex, local.az.stream_analytics_output_mssql.name_unique)) > 0
    } : null
    stream_analytics_output_servicebus_queue = lookup(var.enabled, "stream_analytics_output_servicebus_queue", false) ? {
      valid_name        = length(regexall(local.az.stream_analytics_output_servicebus_queue.regex, local.az.stream_analytics_output_servicebus_queue.name)) > 0 && length(local.az.stream_analytics_output_servicebus_queue.name) > local.az.stream_analytics_output_servicebus_queue.min_length
      valid_name_unique = length(regexall(local.az.stream_analytics_output_servicebus_queue.regex, local.az.stream_analytics_output_servicebus_queue.name_unique)) > 0
    } : null
    stream_analytics_output_servicebus_topic = lookup(var.enabled, "stream_analytics_output_servicebus_topic", false) ? {
      valid_name        = length(regexall(local.az.stream_analytics_output_servicebus_topic.regex, local.az.stream_analytics_output_servicebus_topic.name)) > 0 && length(local.az.stream_analytics_output_servicebus_topic.name) > local.az.stream_analytics_output_servicebus_topic.min_length
      valid_name_unique = length(regexall(local.az.stream_analytics_output_servicebus_topic.regex, local.az.stream_analytics_output_servicebus_topic.name_unique)) > 0
    } : null
    stream_analytics_reference_input_blob = lookup(var.enabled, "stream_analytics_reference_input_blob", false) ? {
      valid_name        = length(regexall(local.az.stream_analytics_reference_input_blob.regex, local.az.stream_analytics_reference_input_blob.name)) > 0 && length(local.az.stream_analytics_reference_input_blob.name) > local.az.stream_analytics_reference_input_blob.min_length
      valid_name_unique = length(regexall(local.az.stream_analytics_reference_input_blob.regex, local.az.stream_analytics_reference_input_blob.name_unique)) > 0
    } : null
    stream_analytics_stream_input_blob = lookup(var.enabled, "stream_analytics_stream_input_blob", false) ? {
      valid_name        = length(regexall(local.az.stream_analytics_stream_input_blob.regex, local.az.stream_analytics_stream_input_blob.name)) > 0 && length(local.az.stream_analytics_stream_input_blob.name) > local.az.stream_analytics_stream_input_blob.min_length
      valid_name_unique = length(regexall(local.az.stream_analytics_stream_input_blob.regex, local.az.stream_analytics_stream_input_blob.name_unique)) > 0
    } : null
    stream_analytics_stream_input_eventhub = lookup(var.enabled, "stream_analytics_stream_input_eventhub", false) ? {
      valid_name        = length(regexall(local.az.stream_analytics_stream_input_eventhub.regex, local.az.stream_analytics_stream_input_eventhub.name)) > 0 && length(local.az.stream_analytics_stream_input_eventhub.name) > local.az.stream_analytics_stream_input_eventhub.min_length
      valid_name_unique = length(regexall(local.az.stream_analytics_stream_input_eventhub.regex, local.az.stream_analytics_stream_input_eventhub.name_unique)) > 0
    } : null
    stream_analytics_stream_input_iothub = lookup(var.enabled, "stream_analytics_stream_input_iothub", false) ? {
      valid_name        = length(regexall(local.az.stream_analytics_stream_input_iothub.regex, local.az.stream_analytics_stream_input_iothub.name)) > 0 && length(local.az.stream_analytics_stream_input_iothub.name) > local.az.stream_analytics_stream_input_iothub.min_length
      valid_name_unique = length(regexall(local.az.stream_analytics_stream_input_iothub.regex, local.az.stream_analytics_stream_input_iothub.name_unique)) > 0
    } : null
    subnet = lookup(var.enabled, "subnet", false) ? {
      valid_name        = length(regexall(local.az.subnet.regex, local.az.subnet.name)) > 0 && length(local.az.subnet.name) > local.az.subnet.min_length
      valid_name_unique = length(regexall(local.az.subnet.regex, local.az.subnet.name_unique)) > 0
    } : null
    template_deployment = lookup(var.enabled, "template_deployment", false) ? {
      valid_name        = length(regexall(local.az.template_deployment.regex, local.az.template_deployment.name)) > 0 && length(local.az.template_deployment.name) > local.az.template_deployment.min_length
      valid_name_unique = length(regexall(local.az.template_deployment.regex, local.az.template_deployment.name_unique)) > 0
    } : null
    traffic_manager_profile = lookup(var.enabled, "traffic_manager_profile", false) ? {
      valid_name        = length(regexall(local.az.traffic_manager_profile.regex, local.az.traffic_manager_profile.name)) > 0 && length(local.az.traffic_manager_profile.name) > local.az.traffic_manager_profile.min_length
      valid_name_unique = length(regexall(local.az.traffic_manager_profile.regex, local.az.traffic_manager_profile.name_unique)) > 0
    } : null
    user_assigned_identity = lookup(var.enabled, "user_assigned_identity", false) ? {
      valid_name        = length(regexall(local.az.user_assigned_identity.regex, local.az.user_assigned_identity.name)) > 0 && length(local.az.user_assigned_identity.name) > local.az.user_assigned_identity.min_length
      valid_name_unique = length(regexall(local.az.user_assigned_identity.regex, local.az.user_assigned_identity.name_unique)) > 0
    } : null
    virtual_desktop_application_group = lookup(var.enabled, "virtual_desktop_application_group", false) ? {
      valid_name        = length(regexall(local.az.virtual_desktop_application_group.regex, local.az.virtual_desktop_application_group.name)) > 0 && length(local.az.virtual_desktop_application_group.name) > local.az.virtual_desktop_application_group.min_length
      valid_name_unique = length(regexall(local.az.virtual_desktop_application_group.regex, local.az.virtual_desktop_application_group.name_unique)) > 0
    } : null
    virtual_desktop_host_pool = lookup(var.enabled, "virtual_desktop_host_pool", false) ? {
      valid_name        = length(regexall(local.az.virtual_desktop_host_pool.regex, local.az.virtual_desktop_host_pool.name)) > 0 && length(local.az.virtual_desktop_host_pool.name) > local.az.virtual_desktop_host_pool.min_length
      valid_name_unique = length(regexall(local.az.virtual_desktop_host_pool.regex, local.az.virtual_desktop_host_pool.name_unique)) > 0
    } : null
    virtual_desktop_scaling_plan = lookup(var.enabled, "virtual_desktop_scaling_plan", false) ? {
      valid_name        = length(regexall(local.az.virtual_desktop_scaling_plan.regex, local.az.virtual_desktop_scaling_plan.name)) > 0 && length(local.az.virtual_desktop_scaling_plan.name) > local.az.virtual_desktop_scaling_plan.min_length
      valid_name_unique = length(regexall(local.az.virtual_desktop_scaling_plan.regex, local.az.virtual_desktop_scaling_plan.name_unique)) > 0
    } : null
    virtual_desktop_workspace = lookup(var.enabled, "virtual_desktop_workspace", false) ? {
      valid_name        = length(regexall(local.az.virtual_desktop_workspace.regex, local.az.virtual_desktop_workspace.name)) > 0 && length(local.az.virtual_desktop_workspace.name) > local.az.virtual_desktop_workspace.min_length
      valid_name_unique = length(regexall(local.az.virtual_desktop_workspace.regex, local.az.virtual_desktop_workspace.name_unique)) > 0
    } : null
    virtual_machine = lookup(var.enabled, "virtual_machine", false) ? {
      valid_name        = length(regexall(local.az.virtual_machine.regex, local.az.virtual_machine.name)) > 0 && length(local.az.virtual_machine.name) > local.az.virtual_machine.min_length
      valid_name_unique = length(regexall(local.az.virtual_machine.regex, local.az.virtual_machine.name_unique)) > 0
    } : null
    virtual_machine_extension = lookup(var.enabled, "virtual_machine_extension", false) ? {
      valid_name        = length(regexall(local.az.virtual_machine_extension.regex, local.az.virtual_machine_extension.name)) > 0 && length(local.az.virtual_machine_extension.name) > local.az.virtual_machine_extension.min_length
      valid_name_unique = length(regexall(local.az.virtual_machine_extension.regex, local.az.virtual_machine_extension.name_unique)) > 0
    } : null
    virtual_machine_scale_set = lookup(var.enabled, "virtual_machine_scale_set", false) ? {
      valid_name        = length(regexall(local.az.virtual_machine_scale_set.regex, local.az.virtual_machine_scale_set.name)) > 0 && length(local.az.virtual_machine_scale_set.name) > local.az.virtual_machine_scale_set.min_length
      valid_name_unique = length(regexall(local.az.virtual_machine_scale_set.regex, local.az.virtual_machine_scale_set.name_unique)) > 0
    } : null
    virtual_machine_scale_set_extension = lookup(var.enabled, "virtual_machine_scale_set_extension", false) ? {
      valid_name        = length(regexall(local.az.virtual_machine_scale_set_extension.regex, local.az.virtual_machine_scale_set_extension.name)) > 0 && length(local.az.virtual_machine_scale_set_extension.name) > local.az.virtual_machine_scale_set_extension.min_length
      valid_name_unique = length(regexall(local.az.virtual_machine_scale_set_extension.regex, local.az.virtual_machine_scale_set_extension.name_unique)) > 0
    } : null
    virtual_network = lookup(var.enabled, "virtual_network", false) ? {
      valid_name        = length(regexall(local.az.virtual_network.regex, local.az.virtual_network.name)) > 0 && length(local.az.virtual_network.name) > local.az.virtual_network.min_length
      valid_name_unique = length(regexall(local.az.virtual_network.regex, local.az.virtual_network.name_unique)) > 0
    } : null
    virtual_network_gateway = lookup(var.enabled, "virtual_network_gateway", false) ? {
      valid_name        = length(regexall(local.az.virtual_network_gateway.regex, local.az.virtual_network_gateway.name)) > 0 && length(local.az.virtual_network_gateway.name) > local.az.virtual_network_gateway.min_length
      valid_name_unique = length(regexall(local.az.virtual_network_gateway.regex, local.az.virtual_network_gateway.name_unique)) > 0
    } : null
    virtual_network_gateway_connection = lookup(var.enabled, "virtual_network_gateway_connection", false) ? {
      valid_name        = length(regexall(local.az.virtual_network_gateway_connection.regex, local.az.virtual_network_gateway_connection.name)) > 0 && length(local.az.virtual_network_gateway_connection.name) > local.az.virtual_network_gateway_connection.min_length
      valid_name_unique = length(regexall(local.az.virtual_network_gateway_connection.regex, local.az.virtual_network_gateway_connection.name_unique)) > 0
    } : null
    virtual_network_peering = lookup(var.enabled, "virtual_network_peering", false) ? {
      valid_name        = length(regexall(local.az.virtual_network_peering.regex, local.az.virtual_network_peering.name)) > 0 && length(local.az.virtual_network_peering.name) > local.az.virtual_network_peering.min_length
      valid_name_unique = length(regexall(local.az.virtual_network_peering.regex, local.az.virtual_network_peering.name_unique)) > 0
    } : null
    virtual_wan = lookup(var.enabled, "virtual_wan", false) ? {
      valid_name        = length(regexall(local.az.virtual_wan.regex, local.az.virtual_wan.name)) > 0 && length(local.az.virtual_wan.name) > local.az.virtual_wan.min_length
      valid_name_unique = length(regexall(local.az.virtual_wan.regex, local.az.virtual_wan.name_unique)) > 0
    } : null
    windows_virtual_machine = lookup(var.enabled, "windows_virtual_machine", false) ? {
      valid_name        = length(regexall(local.az.windows_virtual_machine.regex, local.az.windows_virtual_machine.name)) > 0 && length(local.az.windows_virtual_machine.name) > local.az.windows_virtual_machine.min_length
      valid_name_unique = length(regexall(local.az.windows_virtual_machine.regex, local.az.windows_virtual_machine.name_unique)) > 0
    } : null
    windows_virtual_machine_scale_set = lookup(var.enabled, "windows_virtual_machine_scale_set", false) ? {
      valid_name        = length(regexall(local.az.windows_virtual_machine_scale_set.regex, local.az.windows_virtual_machine_scale_set.name)) > 0 && length(local.az.windows_virtual_machine_scale_set.name) > local.az.windows_virtual_machine_scale_set.min_length
      valid_name_unique = length(regexall(local.az.windows_virtual_machine_scale_set.regex, local.az.windows_virtual_machine_scale_set.name_unique)) > 0
    } : null
  }
}
