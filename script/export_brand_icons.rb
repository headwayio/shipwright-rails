#!/usr/bin/env ruby
# frozen_string_literal: true
#
# Exports the Shipwright Pro Figma brand icons (payment + social) as SVG
# files into app/assets/images/shipwright/brand/. Run whenever the Figma
# source changes.
#
# Usage:
#   FIGMA_ACCESS_TOKEN=xxx ruby script/export_brand_icons.rb
#
# Get a Figma personal access token at:
#   https://www.figma.com/settings (scroll to "Personal access tokens")
#
# The token only needs read access to file "Shipwright Pro".

require "json"
require "net/http"
require "uri"
require "fileutils"

FILE_KEY = "2OAb6hdEr7TbfymRLS1u9t"
OUTPUT_DIR = File.expand_path("../app/assets/images/shipwright/brand", __dir__)

# Node ID → output filename (without .svg extension).
# Names match Shipwright Pro's Figma layer names, normalized to kebab-case
# lowercase so Ruby symbol lookups are predictable.
NODES = {
  # Payment / color variants
  "2:828"  => "amex-color",
  "2:832"  => "cash-dollar-color",
  "2:836"  => "paypal-color",
  "2:845"  => "applepay-color",
  "2:849"  => "visa-color",
  "2:852"  => "discover-color",
  "2:864"  => "cash-color",
  "2:868"  => "card-default-color",
  "2:872"  => "mastercard-color",

  # Payment / fill variants
  "2:879"  => "amex-fill",
  "2:883"  => "cash-dollar-fill",
  "2:886"  => "paypal-fill",
  "2:889"  => "cash-fill",
  "2:892"  => "applepay-fill",
  "2:895"  => "visa-fill",
  "2:898"  => "discover-fill",
  "2:901"  => "card-default-fill",
  "2:905"  => "mastercard-fill",

  # Payment / outline variants
  "2:910"  => "amex-outline",
  "2:914"  => "cash-dollar-outline",
  "2:917"  => "paypal-outline",
  "2:920"  => "applepay-outline",
  "2:923"  => "visa-outline",
  "2:926"  => "cash-outline",
  "2:929"  => "card-default-outline",
  "2:933"  => "discover-outline",
  "2:936"  => "mastercard-outline",

  # Social / main row
  "2:944"  => "facebook-color",
  "2:947"  => "youtube-color",
  "2:950"  => "instagram-color",
  "2:955"  => "google-color",
  "2:960"  => "linkedin-color",
  "2:964"  => "apple-color",
  "2:966"  => "snapchat-color",
  "2:969"  => "pinterest-color",
  "2:972"  => "medium-color",
  "2:976"  => "angelist-color",
  "2:1019" => "slack-color",

  # Social / second row
  "2:979"  => "dribbble-color",
  "2:984"  => "figma-color",
  "2:990"  => "discord-color",
  "2:994"  => "clubhouse-color",
  "2:997"  => "tumblr-color",
  "2:1000" => "telegram-color",
  "2:1004" => "tiktok-color",
  "2:1008" => "vk-color",
  "2:1011" => "signal-color",
  "2:1013" => "reddit-color",
  "2:1016" => "github-color",

  # Social / tools row
  "2:1025" => "fb-messenger-color",
  "2:1028" => "skype-color",
  "2:1034" => "spectrum-color",
  "2:1037" => "zoom-color",
  "2:1043" => "facetime-color",
  "2:1046" => "google-meet-color",
  "2:1057" => "behance-color",
  "2:1060" => "invision-color",
  "2:1063" => "apple-brand",
  "2:1066" => "microsoft-color"
}.freeze

def die(msg)
  warn msg
  exit 1
end

token = ENV["FIGMA_ACCESS_TOKEN"] || die("Set FIGMA_ACCESS_TOKEN (https://www.figma.com/settings)")

FileUtils.mkdir_p(OUTPUT_DIR)

# Figma's image endpoint supports up to ~1000 node IDs per call, but rate
# limits encourage batching. We'll batch in groups of 20.
def fetch_image_urls(token, file_key, ids)
  uri = URI("https://api.figma.com/v1/images/#{file_key}?ids=#{ids.join(',')}&format=svg")
  req = Net::HTTP::Get.new(uri)
  req["X-Figma-Token"] = token

  res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(req) }
  raise "Figma API error: #{res.code} #{res.body}" unless res.is_a?(Net::HTTPSuccess)

  body = JSON.parse(res.body)
  if body["err"]
    raise "Figma returned err: #{body['err']}"
  end
  body["images"]
end

def download(url)
  uri = URI(url)
  res = Net::HTTP.get_response(uri)
  raise "Download failed: #{res.code} #{url}" unless res.is_a?(Net::HTTPSuccess)

  res.body
end

ids = NODES.keys
puts "Fetching #{ids.size} brand icon export URLs from Figma..."

urls = {}
ids.each_slice(20) do |batch|
  urls.merge!(fetch_image_urls(token, FILE_KEY, batch))
  sleep 0.25 # polite throttle
end

missing = ids.reject { |id| urls[id] }
unless missing.empty?
  warn "Missing export URLs for: #{missing.map { |id| "#{id} (#{NODES[id]})" }.join(', ')}"
end

downloaded = 0
NODES.each do |node_id, filename|
  url = urls[node_id]
  next unless url

  svg = download(url)
  path = File.join(OUTPUT_DIR, "#{filename}.svg")
  File.write(path, svg)
  downloaded += 1
  puts "  wrote #{filename}.svg"
end

puts "Done. Wrote #{downloaded}/#{NODES.size} SVGs to #{OUTPUT_DIR}"
puts "Review, then `git add app/assets/images/shipwright/brand && git commit`."
