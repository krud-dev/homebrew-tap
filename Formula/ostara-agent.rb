class OstaraAgent < Formula
  desc "Ostara service discovery/relay agent"
  homepage "https://github.com/krud-dev/ostara"
  url "https://github.com/krud-dev/ostara-agent.git",
    branch:   "main",
    tag:      "v0.0.3",
    revision: "a6caa3e72a10e66b9098f00f3f5b7d4f1a7dfb85"
  head "https://github.com/krud-dev/ostara-agent.git", branch: "main"

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
    prefix.install "build/libs/ostara-agent.jar"
    (bin/"ostara-agent").write <<~EOS
      #!/bin/bash
      "#{Formula["openjdk@17"].opt_prefix}/bin/java" -Dconfig.file=#{etc / "ostara-agent.yml"} -jar #{prefix}/ostara-agent.jar "$@"
    EOS
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
