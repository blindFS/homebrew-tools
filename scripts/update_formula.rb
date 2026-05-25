require 'net/http'
require 'json'
require 'digest'

REPO = "blindFS/Glyphlow"
FORMULA_FILE = "glyphlow.rb"

def get_latest_release
  uri = URI("https://api.github.com/repos/#{REPO}/releases/latest")
  req = Net::HTTP::Get.new(uri)
  req['User-Agent'] = 'Ruby/FormulaUpdater'
  req['Authorization'] = "token #{ENV['GITHUB_TOKEN']}" if ENV['GITHUB_TOKEN']
  
  res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
    http.request(req)
  end
  
  if res.code != '200'
    puts "Error fetching latest release: #{res.code} #{res.message}"
    puts res.body
    exit 1
  end
  
  JSON.parse(res.body)
end

def calculate_sha256(url)
  puts "Downloading #{url}..."
  uri = URI(url)
  
  content = nil
  current_url = url
  5.times do
    uri = URI(current_url)
    res = Net::HTTP.get_response(uri)
    if res.is_a?(Net::HTTPRedirection)
      current_url = res['location']
    else
      content = res.body
      break
    end
  end
  
  if content.nil?
    puts "Error: Failed to download asset after redirects."
    exit 1
  end
  
  Digest::SHA256.hexdigest(content)
end

unless File.exist?(FORMULA_FILE)
  puts "Error: #{FORMULA_FILE} not found."
  exit 1
end

formula_content = File.read(FORMULA_FILE)
version_match = formula_content.match(/version "(.+)"/)
sha256_match = formula_content.match(/sha256 "(.+)"/)

unless version_match && sha256_match
  puts "Error: Could not find version or sha256 in #{FORMULA_FILE}."
  exit 1
end

current_version = version_match[1]
current_sha256 = sha256_match[1]
current_revision_match = formula_content.match(/revision (\d+)/)
current_revision = current_revision_match ? current_revision_match[1].to_i : 0

latest_release = get_latest_release
latest_tag = latest_release['tag_name']
latest_version = latest_tag.sub(/^v/, '')
asset = latest_release['assets'].find { |a| a['name'] == 'glyphlow.tar.gz' }

unless asset
  puts "Error: Could not find glyphlow.tar.gz in the latest release (#{latest_tag})."
  exit 1
end

latest_url = asset['browser_download_url']
latest_sha256 = calculate_sha256(latest_url)

v_current = Gem::Version.new(current_version)
v_latest = Gem::Version.new(latest_version)

updated = false

if v_latest > v_current
  puts "New version found: #{latest_version} (current: #{current_version})"
  formula_content.gsub!(/version ".+"/, "version \"#{latest_version}\"")
  formula_content.gsub!(/url ".+"/, "url \"#{latest_url}\"")
  formula_content.gsub!(/sha256 ".+"/, "sha256 \"#{latest_sha256}\"")
  
  # Remove revision if version changed
  if formula_content =~ /revision \d+/
    formula_content.gsub!(/\n  revision \d+/, "")
  end
  updated = true
elsif v_latest == v_current && latest_sha256 != current_sha256
  puts "Same version (#{latest_version}), different hash. Incrementing revision."
  new_revision = current_revision + 1
  formula_content.gsub!(/sha256 ".+"/, "sha256 \"#{latest_sha256}\"")
  
  if current_revision_match
    formula_content.gsub!(/revision \d+/, "revision #{new_revision}")
  else
    # Insert after sha256
    formula_content.gsub!(/(sha256 ".+")/, "\\1\n  revision #{new_revision}")
  end
  updated = true
else
  puts "No update needed. Current: #{current_version}, Latest: #{latest_version}"
  if latest_sha256 == current_sha256
    puts "Hashes match."
  end
end

if updated
  File.write(FORMULA_FILE, formula_content)
  puts "Successfully updated #{FORMULA_FILE}"
  # Output for GitHub Actions
  if ENV['GITHUB_OUTPUT']
    File.open(ENV['GITHUB_OUTPUT'], 'a') do |f|
      f.puts "updated=true"
      f.puts "version=#{latest_version}"
    end
  end
else
  puts "Nothing to do."
  if ENV['GITHUB_OUTPUT']
    File.open(ENV['GITHUB_OUTPUT'], 'a') do |f|
      f.puts "updated=false"
    end
  end
end
