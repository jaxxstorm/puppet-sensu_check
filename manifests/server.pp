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
  $handle         = undef,
  $tags           = [],
  $tip            = undef,
  $type           = undef,
  $event_summary  = undef,
  $check_custom   = undef,
) {

  # None of this will work without the sensu module
  include ::sensu

  # Some validation of params
  validate_re($ensure, '^(present|absent)$')
  validate_array($handlers)
  validate_array($subscribers)
  validate_string($source)
  validate_string($tip)
  validate_string($dependencies)
  validate_array($tags)

  # Right, bear with me here. There's probably a better way..
  # Because puppet vars are immutable, we check if they exist
  # Then if we do, we add their value to a hash so we can merge them later
  # for custom attributes

  if $tip {
    $tip_hash = { tip => $tip }
  }

  if $event_summary {
    validate_string($event_summary)
    $summary_hash = { event_summary => $event_summary }
  }

  if $aggregate {
    validate_bool($aggregate)
  }

  if $tags {
    validate_array($tags)
    $tag_hash = { tags => $tags }
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
    aggregate    => $aggregate,
    source       => $source,
    refresh      => $refresh,
    dependencies => $dependencies,
    type         => $type,
    occurrences  => $occurrences,
    custom       => merge( $tip_hash, $summary_hash, $tag_hash, $check_custom  )
  }

}
