class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://gloo.solo.io"
  url "https://github.com/solo-io/gloo.git",
      :tag      => "v0.21.1",
      :revision => "0e6a2bb39149f74ddf3907691095d0e430b4bc81"
  head "https://github.com/solo-io/gloo.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "00b21bdecf012568c774cb10d59e5fee67d1298041891df93583028b7d688733" => :catalina
    sha256 "c353d159cde379062cf9b3cbef122a46a865e807738fde28bb71db0ffccd710a" => :mojave
    sha256 "f684d5bd17f7dac6e9a7822638fda2797f3a28dbc6bbe137f5416a1eb6cbec74" => :high_sierra
    sha256 "a7de387553c6a9371d4536cc71bc041bac71bde1dd01a3d5e5427bbc3c056342" => :x86_64_linux
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/solo-io/gloo"
    dir.install buildpath.children - [buildpath/".brew_home"]

    cd dir do
      system "dep", "ensure", "-vendor-only"
      system "make", "glooctl", "TAGGED_VERSION=v#{version}"
      bin.install "_output/glooctl"
    end
  end

  test do
    run_output = shell_output("#{bin}/glooctl 2>&1")
    assert_match "glooctl is the unified CLI for Gloo.", run_output

    version_output = shell_output("#{bin}/glooctl version 2>&1")
    assert_match "Client: {\"version\":\"#{version}\"}", version_output

    version_output = shell_output("#{bin}/glooctl version 2>&1")
    assert_match "Server: version undefined", version_output

    # Should error out as it needs access to a Kubernetes cluster to operate correctly
    status_output = shell_output("#{bin}/glooctl get proxy 2>&1", 1)
    assert_match "failed to create proxy client", status_output
  end
end
