# @summary function used to determine the set of needed PuppetDB metrics based on PE version
#
# The list of metrics to pull from PuppetDB depends on the PE version. To avoid
# having a data file for each version we utilize this function to build the
# needed array of hashes.
#
# @return [Array[Hash]]
#   An array of hashes containing name / url pairs for each puppetdb metric.
#
function puppet_metrics_dashboard::puppetdb_metrics() >> Array[Hash] {
  $activemq_metrics = [
    { 'name' => 'amq_metrics',
      'url'  => 'org.apache.activemq:type=Broker,brokerName=localhost,destinationType=Queue,destinationName=puppetlabs.puppetdb.commands' },
  ]

  $base_metrics = [
    { 'name' => 'global_command-parse-time',
      'url'  => 'puppetlabs.puppetdb.mq:name=global.command-parse-time' },
    { 'name' => 'global_discarded',
      'url'  => 'puppetlabs.puppetdb.mq:name=global.discarded' },
    { 'name' => 'global_fatal',
      'url'  => 'puppetlabs.puppetdb.mq:name=global.fatal' },
    { 'name' => 'global_message-persistence-time',
      'url'  => 'puppetlabs.puppetdb.mq:name=global.message-persistence-time' },
    { 'name' => 'global_retried',
      'url'  => 'puppetlabs.puppetdb.mq:name=global.retried' },
    { 'name' => 'global_retry-counts',
      'url'  => 'puppetlabs.puppetdb.mq:name=global.retry-counts' },
    { 'name' => 'global_seen',
      'url'  => 'puppetlabs.puppetdb.mq:name=global.seen' },
    { 'name' => 'global_processed',
      'url'  => 'puppetlabs.puppetdb.mq:name=global.processed' },
    { 'name' => 'global_processing-time',
      'url'  => 'puppetlabs.puppetdb.mq:name=global.processing-time' },
  ]

  $base_metrics_through_4_2 = [
    { 'name' => 'global_generate-retry-message-time',
      'url'  => 'puppetlabs.puppetdb.mq:name=global.generate-retry-message-time' },
    { 'name' => 'global_retry-persistence-time',
      'url'  => 'puppetlabs.puppetdb.mq:name=global.retry-persistence-time' },
  ]

  $storage_metrics = [
    { 'name' => 'storage_add-edges',
      'url'  => 'puppetlabs.puppetdb.storage:name=add-edges' },
    { 'name' => 'storage_add-resources',
      'url'  => 'puppetlabs.puppetdb.storage:name=add-resources' },
    { 'name' => 'storage_catalog-hash',
      'url'  => 'puppetlabs.puppetdb.storage:name=catalog-hash' },
    { 'name' => 'storage_catalog-hash-match-time',
      'url'  => 'puppetlabs.puppetdb.storage:name=catalog-hash-match-time' },
    { 'name' => 'storage_catalog-hash-miss-time',
      'url'  => 'puppetlabs.puppetdb.storage:name=catalog-hash-miss-time' },
    { 'name' => 'storage_gc-catalogs-time',
      'url'  => 'puppetlabs.puppetdb.storage:name=gc-catalogs-time' },
    { 'name' => 'storage_gc-environments-time',
      'url'  => 'puppetlabs.puppetdb.storage:name=gc-environments-time' },
    { 'name' => 'storage_gc-fact-paths',
      'url'  => 'puppetlabs.puppetdb.storage:name=gc-fact-paths' },
    { 'name' => 'storage_gc-params-time',
      'url'  => 'puppetlabs.puppetdb.storage:name=gc-params-time' },
    { 'name' => 'storage_gc-report-statuses',
      'url'  => 'puppetlabs.puppetdb.storage:name=gc-report-statuses' },
    { 'name' => 'storage_gc-time',
      'url'  => 'puppetlabs.puppetdb.storage:name=gc-time' },
    { 'name' => 'storage_new-catalog-time',
      'url'  => 'puppetlabs.puppetdb.storage:name=new-catalog-time' },
    { 'name' => 'storage_new-catalogs',
      'url'  => 'puppetlabs.puppetdb.storage:name=new-catalogs' },
    { 'name' => 'storage_replace-catalog-time',
      'url'  => 'puppetlabs.puppetdb.storage:name=replace-catalog-time' },
    { 'name' => 'storage_replace-facts-time',
      'url'  => 'puppetlabs.puppetdb.storage:name=replace-facts-time' },
    { 'name' => 'storage_resource-hashes',
      'url'  => 'puppetlabs.puppetdb.storage:name=resource-hashes' },
    { 'name' => 'storage_store-report-time',
      'url'  => 'puppetlabs.puppetdb.storage:name=store-report-time' },
  ]

  $numbers = $facts['pe_server_version'] ? {
    /^2015.2/     => {'catalogs' => 6, 'facts' => 4, 'reports' => 6},
    /^2015.3/     => {'catalogs' => 7, 'facts' => 4, 'reports' => 6},
    /^2016.(1|2)/ => {'catalogs' => 8, 'facts' => 4, 'reports' => 7},
    /^2016.(4|5)/ => {'catalogs' => 9, 'facts' => 5, 'reports' => 8},
    /^2017.(1|2)/ => {'catalogs' => 9, 'facts' => 5, 'reports' => 8},
    default       => {'catalogs' => 9, 'facts' => 5, 'reports' => 8},
  }

  $version_specific_metrics = [
    { 'name' => 'mq_replace_catalog_retried',
      'url'  => "puppetlabs.puppetdb.mq:name=replace catalog.${numbers['catalogs']}.retried" },
    { 'name' => 'mq_replace_catalog_retry-counts',
      'url'  => "puppetlabs.puppetdb.mq:name=replace catalog.${numbers['catalogs']}.retry-counts" },
    { 'name' => 'mq_replace_facts_retried',
      'url'  => "puppetlabs.puppetdb.mq:name=replace facts.${numbers['facts']}.retried" },
    { 'name' => 'mq_replace_facts_retry-counts',
      'url'  => "puppetlabs.puppetdb.mq:name=replace facts.${numbers['facts']}.retry-counts" },
    { 'name' => 'mq_store_report_retried',
      'url'  => "puppetlabs.puppetdb.mq:name=store report.${numbers['reports']}.retried" },
    { 'name' => 'mq_store_reports_retry-counts',
      'url'  => "puppetlabs.puppetdb.mq:name=store report.${numbers['reports']}.retry-counts" },
  ]

  $connection_pool_metrics = [
    { 'name' => 'PDBReadPool_pool_ActiveConnections',
      'url'  => 'puppetlabs.puppetdb.database:name=PDBReadPool.pool.ActiveConnections' },
    { 'name' => 'PDBReadPool_pool_IdleConnections',
      'url'  => 'puppetlabs.puppetdb.database:name=PDBReadPool.pool.IdleConnections' },
    { 'name' => 'PDBReadPool_pool_PendingConnections',
      'url'  => 'puppetlabs.puppetdb.database:name=PDBReadPool.pool.PendingConnections' },
    { 'name' => 'PDBReadPool_pool_TotalConnections',
      'url'  => 'puppetlabs.puppetdb.database:name=PDBReadPool.pool.TotalConnections' },
    { 'name' => 'PDBReadPool_pool_Usage',
      'url'  => 'puppetlabs.puppetdb.database:name=PDBReadPool.pool.Usage' },
    { 'name' => 'PDBReadPool_pool_Wait',
      'url'  => 'puppetlabs.puppetdb.database:name=PDBReadPool.pool.Wait' },
    { 'name' => 'PDBWritePool_pool_ActiveConnections',
      'url'  => 'puppetlabs.puppetdb.database:name=PDBWritePool.pool.ActiveConnections' },
    { 'name' => 'PDBWritePool_pool_IdleConnections',
      'url'  => 'puppetlabs.puppetdb.database:name=PDBWritePool.pool.IdleConnections' },
    { 'name' => 'PDBWritePool_pool_PendingConnections',
      'url'  => 'puppetlabs.puppetdb.database:name=PDBWritePool.pool.PendingConnections' },
    { 'name' => 'PDBWritePool_pool_TotalConnections',
      'url'  => 'puppetlabs.puppetdb.database:name=PDBWritePool.pool.TotalConnections' },
    { 'name' => 'PDBWritePool_pool_Usage',
      'url'  => 'puppetlabs.puppetdb.database:name=PDBWritePool.pool.Usage' },
    { 'name' => 'PDBWritePool_pool_Wait',
      'url'  => 'puppetlabs.puppetdb.database:name=PDBWritePool.pool.Wait' },
  ]

  $ha_sync_metrics = [
    { 'name' => 'ha_last-sync-succeeded',
      'url'  => 'puppetlabs.puppetdb.ha:name=last-sync-succeeded' },
    { 'name' => 'ha_seconds-since-last-successful-sync',
      'url'  => 'puppetlabs.puppetdb.ha:name=seconds-since-last-successful-sync' },
    { 'name' => 'ha_failed-request-counter',
      'url'  => 'puppetlabs.puppetdb.ha:name=failed-request-counter' },
    { 'name' => 'ha_sync-duration',
      'url'  => 'puppetlabs.puppetdb.ha:name=sync-duration' },
    { 'name' => 'ha_catalogs-sync-duration',
      'url'  => 'puppetlabs.puppetdb.ha:name=catalogs-sync-duration' },
    { 'name' => 'ha_reports-sync-duration',
      'url'  => 'puppetlabs.puppetdb.ha:name=reports-sync-duration' },
    { 'name' => 'ha_factsets-sync-duration',
      'url'  => 'puppetlabs.puppetdb.ha:name=factsets-sync-duration' },
    { 'name' => 'ha_nodes-sync-duration',
      'url'  => 'puppetlabs.puppetdb.ha:name=nodes-sync-duration' },
    { 'name' => 'ha_record-transfer-duration',
      'url'  => 'puppetlabs.puppetdb.ha:name=record-transfer-duration' },
  ]

  # lint:ignore:140chars
  $returned_value = $facts['pe_server_version'] ? {
    /^2015./ =>
      $activemq_metrics,
    /^2016\.[45]\./ =>
      $activemq_metrics + $base_metrics + $base_metrics_through_4_2 + $storage_metrics + $connection_pool_metrics + $version_specific_metrics + $ha_sync_metrics,
    /^2016./ =>
      $activemq_metrics + $base_metrics + $base_metrics_through_4_2 + $storage_metrics + $connection_pool_metrics + $version_specific_metrics,
    /^201[78]\./ =>
      $activemq_metrics + $base_metrics + $storage_metrics + $connection_pool_metrics + $version_specific_metrics + $ha_sync_metrics,
    default  =>
      $base_metrics + $storage_metrics + $connection_pool_metrics + $version_specific_metrics,
  }
  # lint:endignore
}
