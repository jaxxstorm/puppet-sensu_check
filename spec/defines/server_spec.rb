require 'spec_helper'

describe 'sensu_check::server' do

  let(:title) { 'example_check' }

  let(:facts) {{
    :ipaddress => '127.0.0.1',
    :osfamily => 'RedHat',
    :operatingsystem => 'CentOS',
    :puppetversion => '3.8.3',
  }}

  context 'no subscribers' do
    let(:params) { { :command => 'foo' }}
    it {
        should raise_error(Puppet::Error, /Must pass subscribers/)
    }
  end # End no subscribers check

  context 'basic check' do
    let(:params) { { :command => 'foo', :subscribers => ['sub1', 'sub2'] }}
    it {
      should contain_sensu__check('example_check') \
        .with_ensure('present') \
        .with_command('foo') \
        .with_interval(60) \
        .with_standalone(false) \
        .with_subscribers(['sub1', 'sub2']) \
        .with_handlers(['default']) \
    } 
  end # end basic check

  context 'set sensu builtin params' do
    let(:params) { { :command => 'foo', :subscribers => ['sub1', 'sub2'], :interval => 120, :handlers => ['handler1', 'handler2'], :ttl => 30, :source => 'source_client', :refresh => '10', :dependencies => 'another_check', :occurrences => 5, :aggregate => true   }}
    it {
      should contain_sensu__check('example_check') \
        .with_ensure('present') \
        .with_subscribers(['sub1', 'sub2']) \
        .with_command('foo') \
        .with_interval(120) \
        .with_handlers(['handler1', 'handler2']) \
        .with_ttl(30) \
        .with_source('source_client') \
        .with_refresh(10) \
        .with_dependencies('another_check') \
        .with_occurrences(5) \
        .with_aggregate(true)
    }
  end # end sensu params

  context 'set custom params' do
    let(:params) { { :command => 'foo', :subscribers => ['sub1', 'sub2'], :tip => 'A short sharp tip', :event_summary => 'A longer event summary', :tags => ['tag1', 'tag2'] }}
    it {
      should contain_sensu__check('example_check') \
        .with_ensure('present') \
        .with_command('foo') \
        .with_interval(60) \
        .with_handlers(['default']) \
        .with_subscribers(['sub1', 'sub2']) \
        .with_custom({
          "tip" => "A short sharp tip",
          "event_summary" => "A longer event summary",
          "tags" => ['tag1', 'tag2']
        })
    }
  end # End custom params




end
