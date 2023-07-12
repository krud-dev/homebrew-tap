class OstaraAgent < Formula
  desc "Ostara service discovery/relay agent"
  homepage "https://github.com/krud-dev/ostara"
  url "https://github.com/krud-dev/ostara-agent.git",
    branch:   "main",
    tag:      "v0.0.2",
    revision: "b298e27769bc7907b535d45de8b1e852a3091666"
  head "https://github.com/krud-dev/ostara-agent.git", branch: "main"

  bottle do
    root_url "https://github.com/krud-dev/homebrew-tap/releases/download/ostara-agent-0.0.2"
    sha256 cellar: :any_skip_relocation, ventura:      "79ef0f250ee28ce846e0801a8653fe8ee87efb70de0087e91912f99fe19db68a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "58e36e07ec28438ceca9e47bc02ba8b8c4df42882e0631ee9168a5d3b8baea19"
  end
  depends_on "openjdk@17"

  service do
    run [opt_bin/"ostara-agent", "start"]
    keep_alive true
    error_log_path var / "log/ostara-agent.log"
    log_path var / "log/ostara-agent.log"
    working_dir var
  end

  def install
    system "./gradlew", "bootJar"
    inreplace "scripts/ostara-agent", "##PREFIX##", prefix.to_s
    inreplace "scripts/ostara-agent", "##JAVA_HOME##", Formula["openjdk@17"].opt_prefix
    inreplace "scripts/ostara-agent", "##CONFIGFILE##", etc / "ostara-agent.yml"
    prefix.install "build/libs/ostara-agent.jar"
    bin.install "scripts/ostara-agent"
  end

  def caveats
    <<~EOS
      Thanks for installing ostara-agent!

      To get started, you need to do a few things:

      1. Run `ostara-agent setup` to set things up.
      2. Run `ostara-agent start` to start the agent or use `brew services start ostara-agent`.
    EOS
  end

  test do
    system bin/"ostara-agent", "version"
  end
end
