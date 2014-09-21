# === Parameters
#
# [*pid_dir*]
#   pid directory. Default: /var/run/flapjack/
# [*log_dir*]
#   log directory. Default: /var/log/flapjack/
# [*log_level*]
#   log level. Default: INFO
# [*syslog_errors*]
#   send errors to syslog??. Default: yes
# [*embedded_redis*]
#   use embedded redis. Default: true
# [*redis_host*]
#   redis host. Default: localhost
# [*redis_port*]
#   redis port. Default: 6380
# [*redis_db*]
#   redis database. Default: 0
# [*processor_enabled*]
#   Processes monitoring events off the *events* queue. Default: yes
# [*processor_queue*]
#   *events* queue. Default: events
# [*notifier_queue*]
#   *notifications* queue. Default: notifications
# [*archive_events*]
#   archive events. Default: true
# [*events_archive_maxage*]
#  Default: 10800
# [*new_check_scheduled_maintenance_duration*]
#  Default: 100 years
# [*new_check_scheduled_maintenance_ignore_tags*]
#  Default: - bypass_ncsm
# [*processor_log_level*]
#  Default: INFO
# [*processor_syslog_errors*]
#  Default: true
# [*notifier_enabled*]
#  enable notifier. Default: yes
# [*notifier_queue*]
#  notifier queue. Default: notifications
# [*notifier_email_queue*]
#  notifier email queue. Default email_notifications
# [*notifier_sms_queue*]
#  notifier sms queue. Default sms_notifications
# [*notifier_sms_twilio_queue*]
#  notifier sms_twilio queue. Default sms_twilio_notifications
# [*notifier_sns_queue*]
#  notifier sns queue. Default sns_notifications
# [*notifier_jabber_queue*]
#  notifier jabber queue. Default jabber_notifications
# [*notifier_pagerduty_queue*]
#  notifier pagerduty queue. Default pagerduty_notifications
# [*notification_log_file*]
#  notification log file. Default: /var/log/flapjack/notification.log
# [*default_contact_timezone*]
#  Default: UTC
# [*notifier_log_level*]
#  Default: INFO
# [*notifier_syslog_errors*]
#  Default: yes
# [*nagios_receiver_enabled*]
#  Default: true
# [*nagios_receiver_fifo*]
#  Default: /var/cache/nagios3/event_stream.fifo
# [*ncsa_receiver_enabled*]
#  Default: true
# [*ncsa_receiver_fifo*]
#  Default: /var/lib/nagios3/rw/nagios.cmd
# [*gateways_email_enabled*]
#  Default: no
# [*gateways_email_queue*]
#  Default: email_notifications
# [*gateways_email_loglevel*]
#  Default: INFO
# [*gateways_email_syslog_errors*]
#  Default: yes
# [*gateways_email_smtp_host*]
#  Default: 127.0.0.1
# [*gateways_email_smtp_port*]
#  Default: 1025
# [*gateways_email_smtp_starttls*]
#  Default: false
# [*gateways_email_smtp_auth*]
#  Default: false
# [*gateways_email_smtp_auth_username*]
#  Default: undef
# [*gateways_email_smtp_auth_password*]
#  Default: undef
# [*gateways_sms_enabled*]
#  Default: no
# [*gateways_sms_queue*]
#  Default: sms_notifications
# [*gateways_sms_loglevel*]
#  Default: INFO
# [*gateways_sms_syslog_errors*]
#  Default: yes
# [*gateways_sms_endpoint*]
#  Default: 'https://www.messagenet.com.au/dotnet/Lodge.asmx/LodgeSMSMessage'
# [*gateways_sms_endpoint_username*]
#  Default: "username"
# [*gateways_sms_endpoint_password*]
#  Default: "password"
# [*gateways_sms_twilio_enabled*]
#  Default: no
# [*gateways_sms_twilio_queue*]
#  Default: sms_twilio_notifications
# [*gateways_sms_twilio_loglev*]
#  Default: INFO
# [*gateways_sms_twilio_syslog_errors*]
#  Default: yes
# [*gateways_sms_twilio_account_sid*]
#  Default: "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
# [*gateways_sms_twilio_auth_toke*]
#  Default: "yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy"
# [*gateways_sms_twilio_from*]
#  Default: "+1xxxxxxxxxx"
# [*gateways_sns_enabled*]
#  Default: no
# [*gateways_sns_queue*]
#  Default: sns_notifications
# [*gateways_sns_access_key*]
#  Default: AKIAIOSFODNN7EXAMPLE
# [*gateways_sns_secret_key*]
#  Default: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
# [*gateways_jabber_enabled*]
#  Default: no
# [*gateways_jabber_queue*]
#  Default: jabber_notifications
# [*gateways_jabber_server*]
#  Default: "jabber.example.com"
# [*gateways_jabber_port*]
#  Default: 5222
# [*gateways_jabber_id*]
#  Default: "flapjack@jabber.example.com"
# [*gateways_jabber_password*]
#  Default: "good-password"
# [*gateways_jabber_alias*]
#  Default: "flapjack"
# [*gateways_jabber_identifiers*]
#  Default: - "@flapjack"
# [*gateways_jabber_rooms*]
#  Default: - "gimp@conference.jabber.example.com"
# [*gateways_jabber_loglevel*]
#  Default: INFO
# [*gateways_jabber_syslog_errors*]
#  Default: yes
# [*gateways_pagerduty_enabled*]
#  Default: no
# [*gateways_pagerduty_queue*]
#  Default: pagerduty_notifications
# [*gateways_pagerduty_loglevel*]
#  Default: INFO
# [*gateways_pagerduty_syslog_errors*]
#  Default: yes
# [*web_enabled*]
# Default: yes
# [*web_port*]
# Default: 3080
# [*web_timeout*]
#  Default: 300
# [*web_auto_refresh*]
#  Seconds between auto_refresh of entities/checks pages.  Set to 0 to disable. Default 120
# [*web_access_log*]
#  Default: "/var/log/flapjack/web_access.log"
# [*web_api_url*]
# Default: "http://localhost:3081/"
# [*logo_image_path*]
# Default: "/etc/flapjack/web/custom_logo/flapjack-2013-notext-transparent-300-300.png"
# [*web_loglevel*]
#  Default: INFO
# [*web_syslog_errors*]
#  Default: yes
# [*jsonapi_enabled*]
# Default: yes
# [*jsonapi_port*]
# Default: 3081
# [*jsonapi_timeout*]
#  Default: 300
# [*jsonapi_access_log*]
#  Default: "/var/log/flapjack/jsonapi_access.log"
# [*jsonapi_base_url*]
#  Default: "http://localhost:3081/"
# [*jsonapi_loglevel*]
#  Default: INFO
# [*jsonapi_syslog_errors*]
#  Default: yes
# [*oobetet_enabled*]
#  Default: no
# [*oobetet_server*]
#  Default: "jabber.example.com"
# [*oobetet_port*]
#  Default: 5222
# [*oobetet_jabber_id*]
#  Default: "flapjacktest@jabber.example.com"
# [*oobetet_jabber_password*]
#  Default: "nuther-good-password"
# [*oobetet_jabber_alias*]
#  Default: "flapjacktest"
# [*oobetet_watched_check*]
#  Default: "PING"
# [*oobetet_watched_entity*]
#  Default: "foo.example.com"
# [*oobetet_max_latency*]
#  Default: 300
# [*oobetet_pagerduty_contact*]
# Default: "11111111111111111111111111111111"
# [*oobetet_jabber_rooms*]
# Default: "flapjacktest@conference.jabber.example.com"
# [*oobetet_loglevel*]
#  Default: INFO
# [*jsonapi_oobetet_errors*]
#  Default: yes



class flapjack {

  class{'flapjack::apt': } ->
  class{'flapjack::install': } ->
  class{'flapjack::config': } ~>
  class{'flapjack::service': } ->
  class{'flapjack::flapjackfeeder': } ->
  Class['flapjack']
}
