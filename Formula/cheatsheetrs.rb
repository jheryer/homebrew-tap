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
      bin.install "cheatsheet"
    end
  
    def post_install
      
        cheatsheets_dir = ENV["HOME"]/".cheatsheets"
        mkdir_p cheatsheets_dir unless cheatsheets_dir.exist?
      
        unless (cheatsheets_dir/"sheets").exist?
          cp_r prefix/"sheets", cheatsheets_dir
        end
      
        ohai "Setting CHEAT_SHEET_PATH environment variable"
        ENV["CHEAT_SHEET_PATH"] = "#{cheatsheets_dir}"
      
        case ENV["SHELL"]
        when %r{/bash$}
          shell_config_file = "~/.bashrc"
        when %r{/zsh$}
          shell_config_file = "~/.zshrc"
        else
          shell_config_file = ""
        end
      
        if shell_config_file != ""
          open(shell_config_file, "a") do |file|
            file.puts "\n# Set CHEAT_SHEET_PATH for Cheatsheet CLI"
            file.puts "export CHEAT_SHEET_PATH=#{cheatsheets_dir}"
          end
          ohai "You may need to restart your terminal or run 'source #{shell_config_file}' for the changes to take effect."
        else
          ohai "Unable to determine the shell configuration file to update. Please set the CHEAT_SHEET_PATH environment variable manually in your shell configuration file."
        end
      end
  
    test do
      system "#{bin}/cheatsheet", "--version"
    end
  end