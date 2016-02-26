# == Definition: flapjack::config::template_config
#
# This is a private definition and should not be used in normal modules.
#
# === Parameters:
# * path (string): The path where the templates hash should be injected.
# * templates (hash): Hash of Templates. Eg.
#     rollup_subject.text: '/etc/flapjack/templates/email/rollup_subject.text.erb'
#     alert_subject.text: '/etc/flapjack/templates/email/alert_subject.text.erb'
#     rollup.text: '/etc/flapjack/templates/email/rollup.text.erb'
#     alert.text: '/etc/flapjack/templates/email/alert.text.erb'
#     rollup.html: '/etc/flapjack/templates/email/rollup.html.erb'
#     alert.html: '/etc/flapjack/templates/email/alert.html.erb'
#
# === Authors
#
# Nicolas Truyens <nicolas@truyens.com>
#
define flapjack::config::template_config (
  $path,
  $templates,
) {
  if ($templates != undef) {
    validate_hash($templates)

    $yaml = inline_template('<%= a = {}; @templates.each { |k,v| a["#{@name}_templates_#{k}"] = {"key" => "#{@path}/templates/#{k}", "value" => "#{v}"} }; a.to_yaml %>')
    $parsed_templates = parseyaml($yaml)

    create_resources('yaml_setting', $parsed_templates)
  }
}
