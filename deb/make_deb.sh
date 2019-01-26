#!/bin/bash
#
# It is recommended to use fakeroot when running this script

mkdir -p mkpdf_all/DEBIAN
cp control mkpdf_all/DEBIAN/control
install -Dm 755 ../mkpdf mkpdf_all/usr/bin/mkpdf
install -Dm 755 ../furbishtex/furbishtex mkpdf_all/usr/bin/furbishtex
install -Dm 644 ../furbishtex/default.sed mkpdf_all/usr/lib/furbishtex/default.sed
install -Dm 644 ../mkpdf.1.gz mkpdf_all/usr/share/man/man1/mkpdf.1.gz
dpkg-deb --build mkpdf_all
