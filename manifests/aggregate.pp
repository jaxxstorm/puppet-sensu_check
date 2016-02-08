# A server side sensu check
define sensu_check::aggregate (
  $warning_threshold,
  $critical_threshold,
  $sensu_api,
  $sensu_password,
  $subscribers,
  $command            = "/etc/sensu/plugins/check-aggregate.rb -c ${name} -a ${sensu_api} -u ${sensu_user} -p ${sensu_password} -W ${warning_threshold} -C ${critical_threshold} ",
  $ensure             = 'present',
  $sensu_user         = 'sensu',
  $interval           = 60,
  $handlers           = ['default'],
  $standalone         = true, # true by default, but can be overriden
  $ttl                = undef,
  $source             = undef,
  $refresh            = undef,
  $dependencies       = undef,
  $occurrences        = undef,
  $aggregate          = undef,
  $handler            = undef,
  $tags               = undef,
  $tip                = undef,
  $page               = undef,
  $type               = undef,
  $create_ticket      = undef,
  $check_custom       = undef,
) {

  # None of this will work without the sensu module
  require ::sensu

  # Some validation of params
  validate_re($ensure)
  validate_array($handlers)
  validate_array($subscribers)
  validate_string($source)
  validate_string($tip)
  validate_string($sensu_api)
  validate_string($sensu_password)
  validate_string($dependencies)
  validate_array($tags)
  validate_bool($page)
  validate_bool($create_ticket)
  validate_bool($aggregate)
  validate_hash($check_custom)

  # Right, bear with me here. There's probably a better way..
  # Because puppet vars are immutable, we check if they exist
  # Then if we do, we add their value to a hash so we can merge them later
  # for custom attributes

  if $tip {
    $tip_hash = { tip => $tip }
  }

  if $page {
    $page_hash = { page => $page }
  }

  if $create_ticket {
    $ticket_hash = { create_ticket => $create_ticket }
  }

  sensu::check { $name:
    ensure       => $ensure,
    handlers     => $handlers,
    handle       => $handle,
    subscribers  => $subscribers,
    command      => $command,
    interval     => $interval,
    standalone   => $standalone,
    ttl          => $ttl,
    source       => $source,
    refresh      => $refresh,
    dependencies => $dependencies,
    type         => $type,
    occurrences  => $occurrences,
    custom       => merge( $tip_hash, $page_hash, $ticket_hash, $check_custom  )
  }

}
