<p>
  <div align="center">
  <h1>
    extract-isbn.rb - Extract ISBN from PDF/EPUB<br /> <br />
    <a href="https://github.com/skyme5/extract-isbn">
      <img
        src="https://img.shields.io/badge/ruby-%23CC342D.svg?style=for-the-badge&logo=ruby&logoColor=white"
        alt="Javascript"
      />
    </a>
    <a href="https://github.com/rubocop/rubocop">
      <img
        src="https://img.shields.io/badge/code_style-rubocop-brightgreen.svg?style=for-the-badge"
        alt="Rubocop"
      />
    </a>
    <a href="https://github.com/skyme5">
      <img
        src="https://img.shields.io/badge/github-%23121011.svg?style=for-the-badge&logo=github&logoColor=white"
        alt="GITHUB"
      />
    </a>
    <a href="https://opensource.org/licenses/MIT">
      <img
        src="https://img.shields.io/github/license/skyme5/puppeteer-bulk-print?color=blue&style=for-the-badge"
        alt="License: MIT"
      />
    </a>
    <a href="https://buymeacoffee.com/skyme5" target="_blank"><img src="https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png" alt="Buy Me A Coffee" style="height: 30px !important;width: auto !important;" ></a>
  </h1>
  </div>
</p>

## Extract ISBN from PDF/EPUB files using pdftotext utility

This will try to look for possible match from first and last few pages of the book and metadata. If a match is found and validated, the ISBN will be appended to the filename (`%filename_[ISBN].%ext`)

## USAGE

```bash
 ruby extract-isbn.rb -r dir
```

You can specify `-r` options to look for files recursively

## Requirements

Behind the scenes this package leverages [pdftotext](https://poppler.freedesktop.org/). You can verify if the binary installed on your system by issueing this command:

```bash
which pdftotext
```

If it is installed it will return the path to the binary.

To install the binary you can use this command on Ubuntu or Debian:

```bash
apt-get install poppler-utils
```

On a mac you can install the binary using brew

```bash
brew install poppler
```

If you're on RedHat or CentOS use this:

```bash
yum install poppler-utils
```

### Ruby dependency

Script requires `lisbn` gem to be installed

```bash
gem install --user lisbn
```
