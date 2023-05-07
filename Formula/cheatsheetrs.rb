require 'fileutils'
class Cheatsheetrs < Formula
    desc "cheatsheet is a command-line tool written in Rust that lets users quickly view cheat sheets on the command line."
    homepage "https://github.com/jheryer/cheatsheetrs"
    version "0.1.0"
    license "MIT License"
 
    if Hardware::CPU.intel?
      url "https://github.com/jheryer/cheatsheetrs/releases/download/v0.1.0/cheatsheet-0.1.0-x86_64-apple-darwin.tar.gz"
      sha256 "c096407eb86a71d6bb196d97967a728f7dd2f6f183f9be5518cf4d7786b4625f"
    elsif Hardware::CPU.arm?
      url "https://github.com/jheryer/cheatsheetrs/releases/download/v0.1.0/cheatsheet-0.1.0-aarch64-apple-darwin.tar.gz"
      sha256 "8205cf60a0d8f435f739d698f6ce2c98459b0feedb265fa70f596a8a2cce6068"
    end 

    def install
      create_wrapper
      prefix.install "sheets"
      libexec.install "cheatsheet"
      bin.install "cheatsheet_wrapper" => "cheatsheet"
    end
  
    def post_install
      ohai "Sheets location: CHEAT_SHEET_PATH=#{HOMEBREW_PREFIX}/Cellar/#{name}/#{version}/sheets"
    end

    private def create_wrapper
      wrapper = "#!/usr/bin/env bash
      export CHEAT_SHEET_PATH=\"${CHEAT_SHEET_PATH:-/opt/homebrew/Cellar/cheatsheetrs/0.1.0/sheets}\"
      #{HOMEBREW_PREFIX}/Cellar/#{name}/#{version}/libexec/cheatsheet \"$@\""
      File.write('cheatsheet_wrapper',wrapper)
    end

    test do
      system "#{bin}/cheatsheet", "--version"
    end
  end