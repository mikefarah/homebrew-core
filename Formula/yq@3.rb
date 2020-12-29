class YqAT3 < Formula
  desc "Process YAML documents from the CLI - Version 3"
  homepage "https://github.com/mikefarah/yq"
  url "https://github.com/mikefarah/yq/archive/3.4.1.tar.gz"
  sha256 "73259f808d589d11ea7a18e4cd38a2e98b518a6c2c178d1ec57d9c5942277cb1"
  license "MIT"

  keg_only :versioned_formula

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/mikefarah/yq").install buildpath.children

    cd "src/github.com/mikefarah/yq" do
      system "go", "build", "-o", bin/"yq"
      prefix.install_metafiles

      (bash_completion/"yq").write Utils.safe_popen_read("#{bin}/yq", "shell-completion", "-V=bash")
      (zsh_completion/"_yq").write Utils.safe_popen_read("#{bin}/yq", "shell-completion", "-V=zsh")
      (fish_completion/"yq.fish").write Utils.safe_popen_read("#{bin}/yq", "shell-completion", "-V=fish")
    end
  end

  test do
    assert_equal "key: cat", shell_output("#{bin}/yq n key cat").chomp
    assert_equal "cat", pipe_output("#{bin}/yq r - key", "key: cat", 0).chomp
  end
end
