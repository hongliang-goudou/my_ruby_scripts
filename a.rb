#抓取新浪微博自己发过的评论

require 'curb'
require 'json'

curl    = Curl::Easy.new
baseurl = 'http://weibo.com/aj/commentbox/out?_wv=5&_t=0&__rnd=1376490671189&page='

curl.headers['Accept']          = '*/*'
curl.headers['Accept-Encoding'] = 'none'
curl.headers['Accept-Language'] = 'zh-CN,zh;q=0.8'
curl.headers['Connection']      = 'keep-alive'
curl.headers['Content-Type']    = 'text/html'
curl.headers['Cookie']          = '#此处写你自己的Cookie'
curl.headers['Host']            = 'weibo.com'
curl.headers['Referer']         = 'http://weibo.com/comment/outbox?wvr=1'
curl.headers['User-Agent']      = 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.93 Safari/537.36'

(1..900).each do |page|
  curl.url = "#{baseurl}#{page}"
  #TODO 此处perform如抛异常则需要再次建立链接再次尝试，确保脚本不断
  curl.perform
  result = JSON.parse(curl.body_str).to_s.gsub('\n', "\n").gsub('\t', "")

  File.open("a/#{page}.json", 'w') { |file| file.write(result) }

  puts "#{page} done"
end
