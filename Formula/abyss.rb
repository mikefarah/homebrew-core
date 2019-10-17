class Abyss < Formula
  desc "Genome sequence assembler for short reads"
  homepage "http://www.bcgsc.ca/platform/bioinfo/software/abyss"
  url "https://github.com/bcgsc/abyss/releases/download/2.2.1/abyss-2.2.1.tar.gz"
  sha256 "838c478b0fb5092e508f0253e213a820cd3faaa45546236f43b87a7194aa2cdf"

  bottle do
    cellar :any
    sha256 "b36e77523181b9af7ad7453e32d409e070d2dc9ba40671d37da0d89ccb4f7948" => :catalina
    sha256 "c97c5da6397f990889bc108183aeba752d7dfa0d096ee1362ae5b66352ce08d6" => :mojave
    sha256 "64db8abd2422f7c484a94e3912e9fc607027d47c3491fe533bf4d77a0f30ef3a" => :high_sierra
    sha256 "fe96208a98f962f62ccd572846d817742eef39b20ee8432dd950587b5a919429" => :sierra
    sha256 "a8d82a2c7594c046de3f2dcc0bdb13b1212a5484f3589025cc56fab0028ee707" => :x86_64_linux
  end

  head do
    url "https://github.com/bcgsc/abyss.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "multimarkdown" => :build
  end

  depends_on "boost" => :build
  depends_on "google-sparsehash" => :build
  depends_on "gcc" if OS.mac?
  depends_on "open-mpi"

  fails_with :clang # no OpenMP support

  resource("testdata") do
    url "http://www.bcgsc.ca/platform/bioinfo/software/abyss/releases/1.3.4/test-data.tar.gz"
    sha256 "28f8592203daf2d7c3b90887f9344ea54fda39451464a306ef0226224e5f4f0e"
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--enable-maxk=128",
                          "--prefix=#{prefix}",
                          "--with-boost=#{Formula["boost"].include}",
                          "--with-mpi=#{Formula["open-mpi"].prefix}",
                          "--with-sparsehash=#{Formula["google-sparsehash"].prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make", "install"
  end

  test do
    testpath.install resource("testdata")
    if OS.mac? || which("column")
      system "#{bin}/abyss-pe", "k=25", "name=ts", "in=reads1.fastq reads2.fastq"
    else
      # Fix error: abyss-tabtomd: column: not found
      system "#{bin}/abyss-pe", "unitigs", "scaffolds", "k=25", "name=ts", "in=reads1.fastq reads2.fastq"
    end
    system "#{bin}/abyss-fac", "ts-unitigs.fa"
  end
end
