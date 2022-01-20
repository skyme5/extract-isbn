#!/usr/bin/env ruby
# frozen_string_literal: true

# Extract ISBN from PDF/EPUB files using pdftotext utility.
#
# This will try to look for possible match from first and last
# few pages of the book and metadata. If a match is found and
# validated, the ISBN will be appended to the filename (`%filename_[ISBN].%ext`)
#
#
# USAGE:
#
# ruby isbn-extract.rb -r dir
#
# You can specify -r options to look for files recursively
#

require 'fileutils'

require 'lisbn'

def scan_pdf(file_path)
  pdfinfo = `pdfinfo "#{file_path}"`

  page_count = pdfinfo.scan(/Pages:[^\r\n\d]+(\d+)/).flatten.first.to_i

  # Scan first 10 and last 20 pages
  pdfinfo += `pdftotext -q -l 10 -enc "UTF-8" "#{file_path}" -`
  pdfinfo += `pdftotext -q -f #{page_count - 20} -l #{page_count} -enc "UTF-8" "#{file_path}" -`

  pdfinfo
rescue ArgumentError
  puts format('REGEX_SCAN_ERROR: %s', file_path)
  `pdftotext -q -l 10 -enc "UTF-8" "#{file_path}" -`
end

def scan_epub(file_path)
  opf_text = file_path

  opf_file = `unzip -Z1 "#{file_path}" | grep -e .opf -e html`.strip.split("\n").map(&:strip)
  opf_file.map { |e| format('"%s"', e) }
  opf_text += `unzip -Uc "#{file_path}" #{opf_file.join(' ')}`
  opf_text
end

def parse_isbn(text, file_path)
  text.scan(/(?:ISBN)?(?:-)?(?:10|13)?(?:[:-]+|10|13)?([\d–‐\-X]{10,19})/)
      .flatten
      .map { |e| Lisbn.new(e.gsub(/[^\dX]+/, '')) }
      .uniq
      .select(&:valid?)
      .map(&:isbn13)
rescue ArgumentError
  puts format('REGEX_SCAN_ERROR: %s', file_path)
  []
end

def process_files(file_path)
  file_ext = File.extname(file_path).downcase
  file_text = file_ext == '.pdf' ? scan_pdf(file_path) : scan_epub(file_path)

  isbn = parse_isbn(file_text, file_path)
  return if isbn.empty?

  puts format('ISBN_FOUND: [%s] -> "%s"', isbn.first, file_path)
  new_path = file_path.gsub(file_ext, "_[#{isbn.first}]#{file_ext}")
  puts format('RENAME_FILE: "%s" -> "%s"', file_path, new_path)

  FileUtils.mv(file_path, new_path)
rescue StandardError
  puts format('ERROR: "%s"', file_path)
end

glob_scan = ARGV.include?('-r')

dir_list = ARGV.select { |e| File.directory?(File.expand_path(e)) }
dir_list << '.' if dir_list.empty?

dir_list.flatten.compact.uniq.each do |dir|
  base_path = File.absolute_path?(dir) ? File.expand_path(dir) : dir
  file_list = Dir.glob(glob_scan ? ['**/*.pdf', '**/*.epub'] : ['*.pdf', '*.epub'], File::FNM_CASEFOLD, base: base_path)
                 .reject { |e| e.match?(/_\[?\d+\]?\.(?:pdf|epub)/) }

  file_list.map! { |e| File.join(base_path, e) }

  file_list.each do |file_path|
    puts format('FILE_SCAN: "%s"', file_path)
    process_files(file_path)
  end
end
