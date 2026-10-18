require_relative '../../../../../lib/post_provision_test'

class CronWritableScriptTest < PostProvisionTest
  def initialize
    self.module_name = 'cron_writable_script'
    self.module_path = get_module_path(__FILE__)
    super
  end

  def test_module
    super
    cron_script = %q(sudo sh -c 'crontab -l | awk '\''/^# Puppet Name: writable_cron_script$/ { found=1; next } found && $0 !~ /^#/ && NF >= 6 { print $6; exit }'\'' | xargs -r ls -ld')
    test_local_command('cron script is world-writable?', cron_script, 'rwxrwxrwx')
    test_local_command('cron job exists?', 'sudo crontab -l', 'writable_cron_script')
  end
end

CronWritableScriptTest.new.run
