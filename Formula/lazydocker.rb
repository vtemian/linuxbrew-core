class Lazydocker < Formula
  desc "The lazier way to manage everything docker"
  homepage "https://github.com/jesseduffield/lazydocker"
  url "https://github.com/jesseduffield/lazydocker.git",
      :tag      => "v0.7.5",
      :revision => "945ad95baef908a3fbe90806817d379fabb8de21"

  bottle do
    cellar :any_skip_relocation
    sha256 "c443d21cdf22343873651b28e172e2868de8181df808af9ff2d0293eb8ed6880" => :catalina
    sha256 "ebefc789f2600d695e155e045eb0c8d9c84dafbd50f771a01f1b9e8c50654374" => :mojave
    sha256 "3ccb0867712835fb9a25237757d7ffa04bea871ee198b6a37fbfacdf6297fa1e" => :high_sierra
    sha256 "a203ed96f4982fc99a21d833819604629f293eb12322b74e3affa6c2e3ed8115" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-mod=vendor", "-o", bin/"lazydocker",
      "-ldflags", "-X main.version=#{version} -X main.buildSource=homebrew"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazydocker --version")

    assert_match "reporting: undetermined", shell_output("#{bin}/lazydocker --config")
  end
end
