class Rastair < Formula
  desc "Rust-based command-line tool for genomic data processing"
  homepage "https://www.rastair.com/"
  license :cannot_represent

  if OS.mac?
    if Hardware::CPU.arm?
      url "https://s3.eu-west-2.amazonaws.com/com.rastair.releases/build/release-v2.1.0/rastair-v2.1.0-aarch64-apple-darwin.zip"
      sha256 "def94736d8f77f67afa714bdec30b9edb4b3bdf430438b15d7111bf563e33f50"
    else
      url "https://s3.eu-west-2.amazonaws.com/com.rastair.releases/build/release-v2.1.0/rastair-v2.1.0-x86_64-apple-darwin.zip"
      sha256 "217a7122987ad4fae4e7ae111944daac06ca54e2057b274ce93cc835188c2f1c"
    end
  elsif OS.linux?
    url "https://s3.eu-west-2.amazonaws.com/com.rastair.releases/build/release-v2.1.0/rastair-v2.1.0-x86_64-unknown-linux-gnu.tar.gz"
    sha256 "4bdfa197ba1d6fc58092598c840ae4947cc6da83aade2898fa50d75456e89a05"
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
