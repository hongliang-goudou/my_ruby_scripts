# 检查域名是否可以注册

require 'curb'
require 'json'
require 'sanitize'

curl   = Curl::Easy.new('http://www.china-channel.com/domainSearch.asp')
name   = "bamajia"
checks = [".com", ".net"]
params = checks.map { |c| Curl::PostField.content("ckendomain", c) }

curl.http_post([*params, Curl::PostField.content("en_prefix",  name)])

body   = Sanitize.clean(curl.body_str.force_encoding("utf-8"))
result = body.split(name)[1..-1].map { |line| line.gsub(/\n.*$/, "").strip }

result.each do |line|
  success = !line["已经被注册"]
  line = line.gsub(/\s+.*$/, "")
  domain = "#{name}#{line} #{success ? '还可以注册' : '已被注册'}"

  puts domain
end
