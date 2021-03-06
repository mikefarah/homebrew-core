class Mockolo < Formula
  desc "Efficient Mock Generator for Swift"
  homepage "https://github.com/uber/mockolo"
  url "https://github.com/uber/mockolo/archive/1.2.9.tar.gz"
  sha256 "97054b88ff0609cc4bf1f2bf9bbdb9195a13f8b3abae114b7f757dd2a0731825"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "fec3a87ea85004d173619ec4ca617fe8c55c887d8b0c2ad7d721af720375dc97" => :big_sur
    sha256 "e062429fbb5b3dd2c2afcaf3b8b56c9ba25a91d3e6d1e6cd18415bf9c8cac8d9" => :arm64_big_sur
    sha256 "837170e02d29e1e146242118d2a71f5e3b94c613e5e38e10f347d5ce122c6208" => :catalina
  end

  depends_on xcode: ["12.0", :build]

  def install
    system "swift", "build", "-c", "release", "--disable-sandbox"
    bin.install ".build/release/mockolo"
  end

  test do
    (testpath/"testfile.swift").write("
    /// @mockable
    public protocol Foo {
        var num: Int { get set }
        func bar(arg: Float) -> String
    }")
    system "#{bin}/mockolo", "-srcs", testpath/"testfile.swift", "-d", testpath/"GeneratedMocks.swift"
    assert_predicate testpath/"GeneratedMocks.swift", :exist?
    assert_equal "
    ///
    /// @Generated by Mockolo
    ///
    public class FooMock: Foo {
      public init() { }
      public init(num: Int = 0) {
          self.num = num
      }

      public private(set) var numSetCallCount = 0
      public var num: Int = 0 { didSet { numSetCallCount += 1 } }

      public private(set) var barCallCount = 0
      public var barHandler: ((Float) -> (String))?
      public func bar(arg: Float) -> String {
          barCallCount += 1
          if let barHandler = barHandler {
              return barHandler(arg)
          }
          return \"\"
      }
    }".gsub(/\s+/, "").strip, shell_output("cat #{testpath/"GeneratedMocks.swift"}").gsub(/\s+/, "").strip
  end
end
