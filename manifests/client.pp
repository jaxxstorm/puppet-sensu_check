# A client side sensu check
define sensu_check::client (
  $command,
  $ensure         = 'present',
  $interval       = 60,
  $handlers       = ['default'],
  $ttl            = undef,
  $source         = undef,
  $refresh        = undef,
  $dependencies   = undef,
  $occurrences    = undef,
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
  validate_string($source)
  validate_string($tip)
  validate_string($dependencies)
  validate_array($tags)
  if $check_custom {
    validate_hash($check_custom)
  }

  # Right, bear with me here. There's probably a better way..
  # Because puppet vars are immutable, we check if they exist
  # Then if we do, we add their value to a hash so we can merge them later
  # for custom attributes

  if $tip {
    validate_string($tip)
    $tip_hash = { tip => $tip }
  }

  if $event_summary {
    validate_string($event_summary)
    $summary_hash = { event_summary => $event_summary }
  }

  if $tags {
    validate_array($tags)
    $tag_hash = { tags => $tags }
  }

  sensu::check { $name:
    ensure       => $ensure,
    handlers     => $handlers,
    command      => $command,
    interval     => $interval,
    standalone   => true, # We're a standalone check, so always true
    ttl          => $ttl,
    source       => $source,
    refresh      => $refresh,
    dependencies => $dependencies,
    type         => $type,
    occurrences  => $occurrences,
    custom       => merge( $tip_hash, $summary_hash, $tag_hash, $check_custom  )
  }

}
