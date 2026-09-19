require 'net/http'
require 'json'
require 'digest'

REPO = "blindFS/Glyphlow"

# Every formula shipped by this tap, mapped to the release asset it is built from.
FORMULAS = [
  { file: "glyphlow.rb",     asset: "glyphlow.tar.gz" },
  { file: "glyphlow-cli.rb", asset: "glyphlow-cli.tar.gz" },
].freeze

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
  puts "  Downloading #{url}..."
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

# Rewrites one formula in place when the release has moved on.
# Returns "<name> to <version>" when the file changed, or nil when nothing was done.
def update_formula(spec, latest_release)
  formula_file = spec[:file]
  asset_name = spec[:asset]
  formula_name = File.basename(formula_file, ".rb")

  unless File.exist?(formula_file)
    puts "#{formula_file}: not found, skipping."
    return nil
  end

  formula_content = File.read(formula_file)
  version_match = formula_content.match(/version "(.+)"/)
  sha256_match = formula_content.match(/sha256 "(.+)"/)

  unless version_match && sha256_match
    puts "Error: Could not find version or sha256 in #{formula_file}."
    return nil
  end

  current_version = version_match[1]
  current_sha256 = sha256_match[1]
  current_revision_match = formula_content.match(/revision (\d+)/)
  current_revision = current_revision_match ? current_revision_match[1].to_i : 0

  latest_tag = latest_release['tag_name']
  latest_version = latest_tag.sub(/^v/, '')
  asset = latest_release['assets'].find { |a| a['name'] == asset_name }

  unless asset
    # Older releases only ship the server archive; skip rather than block the
    # other formulas.
    puts "#{formula_file}: no #{asset_name} in #{latest_tag}, skipping."
    return nil
  end

  latest_url = asset['browser_download_url']
  latest_sha256 = calculate_sha256(latest_url)

  v_current = Gem::Version.new(current_version)
  v_latest = Gem::Version.new(latest_version)

  if v_latest > v_current
    puts "#{formula_file}: new version #{latest_version} (current: #{current_version})"
    formula_content.gsub!(/version ".+"/, "version \"#{latest_version}\"")
    formula_content.gsub!(/url ".+"/, "url \"#{latest_url}\"")
    formula_content.gsub!(/sha256 ".+"/, "sha256 \"#{latest_sha256}\"")

    # Remove revision if version changed
    formula_content.gsub!(/\n  revision \d+/, "")
    result = "#{formula_name} to #{latest_version}"
  elsif v_latest == v_current && latest_sha256 != current_sha256
    new_revision = current_revision + 1
    puts "#{formula_file}: same version #{latest_version}, different hash, revision -> #{new_revision}"
    formula_content.gsub!(/sha256 ".+"/, "sha256 \"#{latest_sha256}\"")

    if current_revision_match
      formula_content.gsub!(/revision \d+/, "revision #{new_revision}")
    else
      # Insert after version, matching the layout used by the existing formulas
      formula_content.gsub!(/(version ".+")/, "\\1\n  revision #{new_revision}")
    end
    result = "#{formula_name} to #{latest_version} rev#{new_revision}"
  else
    puts "#{formula_file}: up to date (#{current_version})."
    return nil
  end

  File.write(formula_file, formula_content)
  puts "#{formula_file}: updated."
  result
end

latest_release = get_latest_release
puts "Latest release: #{latest_release['tag_name']}"

updated = FORMULAS.map { |spec| update_formula(spec, latest_release) }.compact

# Output for GitHub Actions
if ENV['GITHUB_OUTPUT']
  File.open(ENV['GITHUB_OUTPUT'], 'a') do |f|
    f.puts "updated=#{!updated.empty?}"
    f.puts "versions=#{updated.join(', ')}"
  end
end

if updated.empty?
  puts "Nothing to do."
else
  puts "Updated: #{updated.join(', ')}"
end
