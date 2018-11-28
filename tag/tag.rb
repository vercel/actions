#!/usr/bin/env ruby
# frozen_string_literal: true

require 'slop'

def docker(command)
  docker_binary = ENV['DOCKER_CMD'] || 'docker'
  `#{docker_binary} #{command}`
end

opts = Slop.parse do |o|
  o.banner = 'usage: tag [options] image-to-tag destination-tag'
  o.separator 'example: tag 5747bb3fa4f7 github/build'
  o.separator ''
  o.separator 'options:'
  o.bool '-l', '--latest', 'tag image as latest', default: true
  o.bool '-r', '--ref', 'tag image with ref', default: true
  o.bool '-s', '--sha', 'tag image with commitish', default: true
  o.bool '-e', '--env', 'write tags to environment file', default: true
  o.string '-f', '--env-file', 'location of environment file',
           default: File.join(Dir.home.to_s, '.profile')
end

if opts.args.length < 2
  puts opts
  exit(1)
end

source_image = opts.args[0]
dest_image = opts.args[1]

docker_command = 'inspect --format '\
  "'{{ index .Config.Labels \"version\" }}' #{source_image}"

version_tag = docker(docker_command).strip
version_tag = nil if version_tag.empty?
major_version_tag = version_tag&.split('.')&.first if version_tag

ref_tag = ENV['GITHUB_REF']&.split('/')&.last if opts[:ref] && ENV['GITHUB_SHA']

sha_tag = ENV['GITHUB_SHA'][0..6] if opts[:sha] && ENV['GITHUB_SHA']

tags = [version_tag, major_version_tag, ref_tag, sha_tag].compact

if tags.empty?
  puts 'I was unable to find a label, ref or SHA for your image, bailing'
  exit(2)
end

tags << 'latest' if opts[:latest]

tags.each do |tag|
  puts "tagging #{source_image} as #{dest_image}:#{tag}"
  docker("tag #{source_image} #{dest_image}:#{tag}")
  if $?.exitstatus != 0
    exit($?.exitstatus)
  end
end

if opts[:env]
  out_file = File.open(opts[:env_file], 'a+')
  data = []
  data << "export IMAGE_SHA=#{sha_tag}" if sha_tag
  data << "export IMAGE_REF=#{ref_tag}" if ref_tag
  data << "export IMAGE_VERSION=#{version_tag}" if version_tag
  data << "export IMAGE_MAJOR_VERSION=#{major_version_tag}" if major_version_tag
  out_file.write(data.join("\n"))
  out_file.close
end
