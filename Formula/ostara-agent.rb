require "formula"

class OstaraAgent < Formula
  homepage "https://github.com/krud-dev/ostara"
  url "https://github.com/krud-dev/ostara-agent.git",
    branch: "main",
    tag: "v0.0.1",
    revision: "7961354de30fe5ce8fd8d95a0874908fc461ddce"
  head "https://github.com/krud-dev/ostara-agent.git", branch: "main"
  depends_on "openjdk@17"

  service do
    java_path = File.join(Formula["openjdk@17"].opt_prefix, "bin", "java")
    run [java_path, "-jar", opt_prefix / "ostara-agent.jar"]
    keep_alive true
    error_log_path var / "log/ostara-agent.log"
    log_path var / "log/ostara-agent.log"
    working_dir var
  end

  def install
    ENV["JAVA_HOME"] = Formula["openjdk@17"].opt_prefix
    system "./gradlew", "bootJar"
    inreplace "scripts/ostara-agent", "##PREFIX##", "#{prefix}"
    prefix.install "build/libs/ostara-agent.jar"
    bin.install "scripts/ostara-agent"
  end

  def caveats
    <<~EOS
      Thanks for installing ostara-agent!

      To get started, you need to do a few things:

      1. Run `ostara-agent setup` to set things up.
      2. Run `ostara-agent start` to start the agent.
      3. Run `ostara-agent status` to check the status of the agent.
    EOS
  end
end
