class MpsYoutube < Formula
  include Language::Python::Virtualenv

  desc "Terminal based YouTube player and downloader"
  homepage "https://github.com/mps-youtube/mps-youtube"
  url "https://files.pythonhosted.org/packages/b1/8e/5156416119545e3f5ba16ec0fdbb2c7d0b57fad9e19ee8554856cd4a41ad/mps-youtube-0.2.8.tar.gz"
  sha256 "59ce3944626fbd1a041e1e1b15714bbd138ebc71ceb89e32ea9470d8152af083"
  license "GPL-3.0-or-later"
  revision 11

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "685285c44e0ee261c44db9203514028ba35eb8fb490e9688afa90ea1be76d40b" => :big_sur
    sha256 "9142932f01ae55a253513a89754b4a9e42219d3116b8dffa4188a3a60f3c66a5" => :catalina
    sha256 "2da76eead581d961641ee9a2daaa8be2357747400d0f75d3c8a490b914896972" => :mojave
  end

  depends_on "mplayer"
  depends_on "python@3.9"

  resource "pafy" do
    url "https://files.pythonhosted.org/packages/7e/02/b70f4d2ad64bbc7d2a00018c6545d9b9039208553358534e73e6dd5bbaf6/pafy-0.5.5.tar.gz"
    sha256 "364f1d1312c89582d97dc7225cf6858cde27cb11dfd64a9c2bab1a2f32133b1e"
  end

  resource "youtube_dl" do
    url "https://files.pythonhosted.org/packages/51/80/d3938814a40163d3598f8a1ced6abd02d591d9bb38e66b3229aebe1e2cd0/youtube_dl-2020.5.3.tar.gz"
    sha256 "e7a400a61e35b7cb010296864953c992122db4b0d6c9c6e2630f3e0b9a655043"
  end

  def install
    venv = virtualenv_create(libexec, "python3")

    %w[youtube_dl pafy].each do |r|
      venv.pip_install resource(r)
    end

    venv.pip_install_and_link buildpath
  end

  def caveats
    <<~EOS
      Install the optional mpv app with Homebrew Cask:
        brew install --cask mpv
    EOS
  end

  test do
    Open3.popen3("#{bin}/mpsyt", "/Drop4Drop x Ed Sheeran,", "da 1,", "q") do |_, _, stderr|
      assert_empty stderr.read, "Some warnings were raised"
    end
  end
end
