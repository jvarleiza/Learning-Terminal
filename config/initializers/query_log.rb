require 'amazon/querylog'

Amazon::QueryLog.setup_logging
Amazon::QueryLog.program = Rails.application.class.parent_name
Amazon::QueryLog.log_dir = Rails.application.config.log_path

Amazon::QueryLog.global_entry_lines = {
  'Realm' => Amazon::Config.global_config.realm,
  'Hostname' => Socket.gethostname,
  'ClientProgram' => 'rails',
  'Marketplace' => 'us'
}

Amazon::QueryLog.log_utc = true
