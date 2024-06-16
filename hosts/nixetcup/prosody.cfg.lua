pidfile = "/run/prosody/prosody.pid"

log = "*syslog"

data_path = "/var/lib/prosody"
plugin_paths = {
  "/nix/store/ngqlq9ry7s3hy2yv6kvv4pys3d0s53d6-jitsi-meet-prosody-1.0.7952/share/prosody-plugins",
}

admins = {}

modules_enabled = {
  "blocklist",
  "bookmarks",
  "bosh",
  "carbons",
  "cloud_notify",
  "csi",
  "dialback",
  "disco",

  "http_files",

  "mam",

  "pep",
  "ping",
  "private",
  "proxy65",
  "register",
  "roster",
  "saslauth",

  "smacks",
  "time",
  "tls",
  "uptime",

  "vcard_legacy",
  "version",

  "websocket",

  "pubsub",
  "smacks",
  "speakerstats",
  "external_services",
  "conference_duration",
  "end_conference",
  "muc_lobby_rooms",
  "muc_breakout_rooms",
  "av_moderation",
  "muc_hide_all",
  "muc_meeting_id",
  "muc_domain_mapper",
  "muc_rate_limit",
  "limits_exception",
  "persistent_lobby",
  "room_metadata",
}

disco_items = {
  { "lobby.meet.muellerbernd.de",         "lobby.meet.muellerbernd.de MUC endpoint" },
  { "internal.auth.meet.muellerbernd.de", "internal.auth.meet.muellerbernd.de MUC endpoint" },
  { "breakout.meet.muellerbernd.de",      "breakout.meet.muellerbernd.de MUC endpoint" },
  { "conference.meet.muellerbernd.de",    "conference.meet.muellerbernd.de MUC endpoint" },
}

allow_registration = false

c2s_require_encryption = true

s2s_require_encryption = true

s2s_secure_auth = false

s2s_insecure_domains = {}

s2s_secure_domains = {}

authentication = "internal_hashed"

http_interfaces = { "*", "::" }

https_interfaces = { "*", "::" }

http_ports = { 5280 }

https_ports = { 5281 }

muc_mapper_domain_base = "meet.muellerbernd.de"

cross_domain_websocket = true
consider_websocket_secure = true

unlimited_jids = {
  "focus@auth.meet.muellerbernd.de",
  "jvb@auth.meet.muellerbernd.de",
}

Component("focus.meet.muellerbernd.de")("client_proxy")
target_address = "focus@auth.meet.muellerbernd.de"

Component("jigasi.meet.muellerbernd.de")("client_proxy")
target_address = "jigasi@auth.meet.muellerbernd.de"

Component("speakerstats.meet.muellerbernd.de")("speakerstats_component")
muc_component = "conference.meet.muellerbernd.de"

Component("conferenceduration.meet.muellerbernd.de")("conference_duration_component")
muc_component = "conference.meet.muellerbernd.de"

Component("endconference.meet.muellerbernd.de")("end_conference")
muc_component = "conference.meet.muellerbernd.de"

Component("avmoderation.meet.muellerbernd.de")("av_moderation_component")
muc_component = "conference.meet.muellerbernd.de"

Component("metadata.meet.muellerbernd.de")("room_metadata_component")
muc_component = "conference.meet.muellerbernd.de"
breakout_rooms_component = "breakout.meet.muellerbernd.de"

Component("conference.meet.muellerbernd.de")("muc")
modules_enabled = { "muc_mam", "vcard_muc" }
name = "Jitsi Meet MUC"
restrict_room_creation = false
max_history_messages = 20
muc_room_locking = false
muc_room_lock_timeout = 300
muc_tombstones = true
muc_tombstone_expiry = 2678400
muc_room_default_public = true
muc_room_default_members_only = false
muc_room_default_moderated = false
muc_room_default_public_jids = true
muc_room_default_change_subject = false
muc_room_default_history_length = 20
muc_room_default_language = "en"
restrict_room_creation = true
storage = "memory"
admins = { "focus@auth.meet.muellerbernd.de" }

Component("breakout.meet.muellerbernd.de")("muc")
modules_enabled = { "muc_mam", "vcard_muc" }
name = "Jitsi Meet Breakout MUC"
restrict_room_creation = false
max_history_messages = 20
muc_room_locking = false
muc_room_lock_timeout = 300
muc_tombstones = true
muc_tombstone_expiry = 2678400
muc_room_default_public = true
muc_room_default_members_only = false
muc_room_default_moderated = false
muc_room_default_public_jids = true
muc_room_default_change_subject = false
muc_room_default_history_length = 20
muc_room_default_language = "en"
restrict_room_creation = true
storage = "memory"
admins = { "focus@auth.meet.muellerbernd.de" }

Component("internal.auth.meet.muellerbernd.de")("muc")
modules_enabled = { "muc_mam", "vcard_muc" }
name = "Jitsi Meet Videobridge MUC"
restrict_room_creation = false
max_history_messages = 20
muc_room_locking = false
muc_room_lock_timeout = 300
muc_tombstones = true
muc_tombstone_expiry = 2678400
muc_room_default_public = true
muc_room_default_members_only = false
muc_room_default_moderated = false
muc_room_default_public_jids = true
muc_room_default_change_subject = false
muc_room_default_history_length = 20
muc_room_default_language = "en"
storage = "memory"
admins = { "focus@auth.meet.muellerbernd.de", "jvb@auth.meet.muellerbernd.de", "jigasi@auth.meet.muellerbernd.de" }

Component("lobby.meet.muellerbernd.de")("muc")
modules_enabled = { "muc_mam", "vcard_muc" }
name = "Jitsi Meet Lobby MUC"
restrict_room_creation = false
max_history_messages = 20
muc_room_locking = false
muc_room_lock_timeout = 300
muc_tombstones = true
muc_tombstone_expiry = 2678400
muc_room_default_public = true
muc_room_default_members_only = false
muc_room_default_moderated = false
muc_room_default_public_jids = true
muc_room_default_change_subject = false
muc_room_default_history_length = 20
muc_room_default_language = "en"
restrict_room_creation = true
storage = "memory"

VirtualHost("auth.meet.muellerbernd.de")
enabled = true
ssl = {
  cafile = "/etc/ssl/certs/ca-bundle.crt",
  key = "/var/lib/jitsi-meet/jitsi-meet.key",
  certificate = "/var/lib/jitsi-meet/jitsi-meet.crt",
}
authentication = "internal_hashed"

VirtualHost("guest.meet.muellerbernd.de")
enabled = true

authentication = "anonymous"
c2s_require_encryption = false

VirtualHost("meet.muellerbernd.de")
enabled = true
ssl = {
  cafile = "/etc/ssl/certs/ca-bundle.crt",
  key = "/var/lib/jitsi-meet/jitsi-meet.key",
  certificate = "/var/lib/jitsi-meet/jitsi-meet.crt",
}

authentication = "jitsi-anonymous"
c2s_require_encryption = false
admins = { "focus@auth.meet.muellerbernd.de" }
smacks_max_unacked_stanzas = 5
smacks_hibernation_time = 60
smacks_max_hibernated_sessions = 1
smacks_max_old_sessions = 1

av_moderation_component = "avmoderation.meet.muellerbernd.de"
speakerstats_component = "speakerstats.meet.muellerbernd.de"
conference_duration_component = "conferenceduration.meet.muellerbernd.de"
end_conference_component = "endconference.meet.muellerbernd.de"

c2s_require_encryption = false
lobby_muc = "lobby.meet.muellerbernd.de"
breakout_rooms_muc = "breakout.meet.muellerbernd.de"
room_metadata_component = "metadata.meet.muellerbernd.de"
main_muc = "conference.meet.muellerbernd.de"

VirtualHost("recorder.meet.muellerbernd.de")
enabled = true

authentication = "internal_plain"
c2s_require_encryption = false
