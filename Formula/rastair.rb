class Rastair < Formula
  desc "Rust-based command-line tool for genomic data processing"
  homepage "https://www.rastair.com/"
  license :cannot_represent

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://s3.eu-west-2.amazonaws.com/com.rastair.releases/build/release-v2.1.1/rastair-v2.1.1-aarch64-apple-darwin.zip"
      sha256 "3bd110eba50454b2a92cde5888cce5db288e5cc8dcef9fea0614a0b0b1cdcf06"
    else
      url "https://s3.eu-west-2.amazonaws.com/com.rastair.releases/build/release-v2.1.1/rastair-v2.1.1-x86_64-apple-darwin.zip"
      sha256 "43e9b2aeb4a7bfce1942707f41fb3307d8264adeac87327418eeafc758b7e352"
    end
  elsif OS.linux?
    url "https://s3.eu-west-2.amazonaws.com/com.rastair.releases/build/release-v2.1.1/rastair-v2.1.1-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "4dfbab24efad0f524ae6469c122c17d1d307a816e6f8b4af7e9bec24f8823b21"
  end

  head do
    url "https://bitbucket.org/bsblabludwig/rastair.git", branch: "main"
    depends_on "cmake" => :build
    depends_on "htslib" => :build
    depends_on "libdeflate" => :build
    depends_on "rust" => :build
  end

  def install
    if build.head?
      # Set environment variables so Rust tool finds the Homebrew libraries
      ENV.prepend_path "PKG_CONFIG_PATH", Formula["htslib"].opt_lib/"pkgconfig"
      ENV.prepend_path "PKG_CONFIG_PATH", Formula["libdeflate"].opt_lib/"pkgconfig"

      system "cargo", "install", *std_cargo_args

      pkgshare.install "scripts/mbias.R", "scripts/QC_report.Rmd"
    else
      bin.install "rastair"
      pkgshare.install "mbias.R", "QC_report.Rmd"
    end

    # Generate and install shell completions
    bash_completion_file = buildpath/"rastair.bash"
    File.write(bash_completion_file, Utils.safe_popen_read(bin/"rastair", "internal", "shell-completions", "bash"))
    bash_completion.install bash_completion_file

    zsh_completion_file = buildpath/"rastair.zsh"
    File.write(zsh_completion_file, Utils.safe_popen_read(bin/"rastair", "internal", "shell-completions", "zsh"))
    zsh_completion.install zsh_completion_file

    fish_completion_file = buildpath/"rastair.fish"
    File.write(fish_completion_file, Utils.safe_popen_read(bin/"rastair", "internal", "shell-completions", "fish"))
    fish_completion.install fish_completion_file
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rastair --version")
  end
end
