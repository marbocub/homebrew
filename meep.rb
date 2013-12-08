require 'formula'

def needs_dotwrp?
  MacOS.prefer_64_bit? and MACOS_VERSION == 10.6
end

def skip_test?
  ARGV.include? '--skip-test'
end

class Meep < Formula
  homepage 'http://ab-initio.mit.edu/meep'
  url 'http://ab-initio.mit.edu/meep/meep-1.2.tar.gz'
  sha1 'a627b201ff149210be42e824667d1ac355790732'

  depends_on 'guile'
  depends_on 'gmp'
  depends_on 'hdf5'
  depends_on 'gsl'
  depends_on 'fftw'
  depends_on 'dotwrp' if needs_dotwrp?
  depends_on 'mit-scheme'
  depends_on 'libctl'
  depends_on 'harminv'
  depends_on 'h5utils'

  def options
    [
      ['--skip-test', 'Skip meep test-suite before installing'],
    ]
  end

  def install
    ENV.fortran
    args = [
            "--disable-debug",
            "--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--with-blas=#{'-ldotwrp ' if needs_dotwrp?}'-framework Accelerate'",
            "--with-lapack=#{'-ldotwrp ' if needs_dotwrp?}'-framework Accelerate'"
    ]

    system "./configure", *args

    system "make"
    system "make check | tee makecheck.log" unless skip_test?
    system "make install"
  end
end
