class Cheatsheetrs < Formula
    desc "cheatsheet is a command-line tool written in Rust that lets users quickly view cheat sheets on the command line."
    homepage "https://github.com/jheryer/cheatsheetrs"
    version "0.1.1"
    license "MIT License"

    if Hardware::CPU.intel?
      url "https://github.com/jheryer/cheatsheetrs/releases/download/v0.1.1/cheatsheet-0.1.1-x86_64-apple-darwin.tar.gz"
      sha256 "4bac93fffdb082dd6776ff822e8edc6d187a6b5ab6ed9322893b416cd18d703c"
    elsif Hardware::CPU.arm?
      url "https://github.com/jheryer/cheatsheetrs/releases/download/v0.1.1/cheatsheet-0.1.1-aarch64-apple-darwin.tar.gz"
      sha256 "969a7db6334049e465bddab8a5210f0588787ff488dd777638e1a085fde565b4"
    end 

    def install
      create_wrapper
      prefix.install "sheets"
      libexec.install "cheatsheet"
      bin.install "cheatsheet_wrapper" => "cheatsheet"
    end
  
    def post_install
      ohai "Sheets location: CHEAT_SHEET_PATH=#{prefix}/sheets"
    end

    private def create_wrapper
      wrapper = "#!/usr/bin/env bash
      export CHEAT_SHEET_PATH=\"$\{CHEAT_SHEET_PATH:-#{prefix}/sheets\}\"
      #{prefix}/libexec/cheatsheet \"$@\""
      File.write('cheatsheet_wrapper',wrapper)
    end

    test do
      system "#{bin}/cheatsheet", "--version"
    end
  end
 
