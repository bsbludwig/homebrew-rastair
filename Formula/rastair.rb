class Rastair < Formula
  desc "Detect genetic variants and methylation from TAPS+/5-base sequencing data"
  homepage "https://www.rastair.com/"
  license :cannot_represent

  # Only non-prerelease tags are picked up; RCs such as v2.2.0-rc.1 are marked
  # as prereleases by the upstream release workflow and skipped here.
  livecheck do
    url :stable
    strategy :github_latest
  end

  head do
    url "https://github.com/bsbludwig/rastair.git", branch: "main"
    depends_on "cmake" => :build
    depends_on "htslib" => :build
    depends_on "libdeflate" => :build
    depends_on "rust" => :build
  end

  on_macos do
    on_arm do
      url "https://github.com/bsbludwig/rastair/releases/download/v2.2.0/rastair-v2.2.0-aarch64-apple-darwin.zip"
      sha256 "6b6d72af39c60cb81f214193475549a94e66e002f7b7e4c73270e5fa6d7bb073"
    end

    on_intel do
      url "https://github.com/bsbludwig/rastair/releases/download/v2.2.0/rastair-v2.2.0-x86_64-apple-darwin.zip"
      sha256 "c4b97ed3b42fdccefb9ad9c67a151d3d544c7657ecf79c82514901d5b5dafb74"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/bsbludwig/rastair/releases/download/v2.2.0/rastair-v2.2.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "05c4d82831e92048a1920a84d0839f7b0da0db4a4964b1497c9345550545d22a"
    end
  end

  def install
    if build.head?
      # Set environment variables so Rust tool finds the Homebrew libraries
      ENV.prepend_path "PKG_CONFIG_PATH", formula_opt_lib("htslib")/"pkgconfig"
      ENV.prepend_path "PKG_CONFIG_PATH", formula_opt_lib("libdeflate")/"pkgconfig"

      system "cargo", "install", *std_cargo_args

      pkgshare.install "scripts/mbias.R", "scripts/QC_report.Rmd"
    else
      bin.install "rastair"
      pkgshare.install "mbias.R", "QC_report.Rmd"
    end

    generate_completions_from_executable(bin/"rastair", "internal", "shell-completions",
                                         shell_parameter_format: :arg)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rastair --version")
  end
end
