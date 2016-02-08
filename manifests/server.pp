# A server side sensu check
define sensu_check::server (
  $command,
  $subscribers,
  $ensure         = 'present',
  $interval       = 60,
  $handlers       = ['default'],
  $ttl            = undef,
  $source         = undef,
  $refresh        = undef,
  $dependencies   = undef,
  $occurrences    = undef,
  $aggregate      = undef,
  $handle        = undef,
  $tags           = undef,
  $tip            = undef,
  $page           = undef,
  $type           = undef,
  $create_ticket  = undef,
  $check_custom   = undef,
) {

  # None of this will work without the sensu module
  require ::sensu

  # Some validation of params
  validate_re($ensure)
  validate_array($handlers)
  validate_array($subscribers)
  validate_string($source)
  validate_string($tip)
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
    standalone   => false, # We're a server side check, so always false
    ttl          => $ttl,
    source       => $source,
    refresh      => $refresh,
    dependencies => $dependencies,
    type         => $type,
    occurrences  => $occurrences,
    custom       => merge( $tip_hash, $page_hash, $ticket_hash, $check_custom  )
  }

}
