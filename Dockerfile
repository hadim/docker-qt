FROM ubuntu:16.04
MAINTAINER Hadrien Mary <hadrien.mary@gmail.com>

# Install core dependencies

RUN apt-get update && \
    apt-get -y install -y \
        gcc g++ build-essential cmake bash libxcb1-dev libicu-dev \
        libssl-dev linux-headers-generic curl git libxrender-dev \
        libpng3 libpng-dev libjpeg-turbo8 libjpeg-turbo8-dev libicu55 libicu-dev \
        libgles2-mesa libgles2-mesa-dev libfreetype6-dev libsqlite3-dev \
	libgstreamer0.10-0 libgstreamer0.10-dev \
        libogg-dev libvorbis-dev bzip2 gperf bison ruby flex && \
    rm -rf /var/lib/apt/lists/*

# Choose Qt version

ENV QT_VERSION_MAJOR 5.9
ENV QT_VERSION 5.9.4

# Compile and install Qt Base

ENV QT_DIST /usr/local/Qt-"$QT_VERSION"
ENV QT_BASE_SRC https://download.qt.io/official_releases/qt/"$QT_VERSION_MAJOR"/"$QT_VERSION"/submodules/qtbase-opensource-src-"$QT_VERSION".tar.xz
ENV QT_BASE_DIR /qtbase-opensource-src-"$QT_VERSION"

RUN curl -sSL $QT_BASE_SRC | tar xJ \
    && cd $QT_BASE_DIR \
    && bash ./configure --help \
    && bash ./configure -opensource -confirm-license -static -no-accessibility -sql-sqlite -sqlite -no-qml-debug \
       -no-harfbuzz -openssl-linked -qt-pcre -no-dbus -nomake tools \
       -no-xkbcommon-evdev -no-xinput2 -no-xcb-xlib -no-glib -qt-xcb -no-compile-examples -nomake examples \
       -no-gif -qt-doubleconversion -no-gtk \
    && make install

ENV PATH $QT_DIST/bin:$PATH

# Compile and install Qt Script

ENV QT_SCRIPT_SRC https://download.qt.io/official_releases/qt/"$QT_VERSION_MAJOR"/"$QT_VERSION"/submodules/qtscript-opensource-src-"$QT_VERSION".tar.xz
ENV QT_SCRIPT_DIR /qtscript-opensource-src-"$QT_VERSION"

RUN curl -sSL $QT_SCRIPT_SRC | tar xJ \
    && cd $QT_SCRIPT_DIR \
    && qmake \
    && make install \
    && cd /

# Compile and install Qt SVG

ENV QT_SVG_SRC https://download.qt.io/official_releases/qt/"$QT_VERSION_MAJOR"/"$QT_VERSION"/submodules/qtsvg-opensource-src-"$QT_VERSION".tar.xz
ENV QT_SVG_DIR /qtsvg-opensource-src-"$QT_VERSION"

RUN curl -sSL $QT_SVG_SRC | tar xJ \
    && cd $QT_SVG_DIR \
    && qmake \
    && make install \
    && cd /

# Compile and install Qt WebKit

ENV QT_WEBKIT_SRC https://download.qt.io/community_releases/"$QT_VERSION_MAJOR"/"$QT_VERSION"/qtwebkit-opensource-src-"$QT_VERSION".tar.xz
ENV QT_WEBKIT_DIR /qtwebkit-opensource-src-"$QT_VERSION"

#RUN curl -sSL $QT_WEBKIT_SRC | tar xJ \
#    && cd $QT_WEBKIT_DIR \
#    && qmake \
#    && make install \
#    && cd /

# Clean compilation files

RUN cd $QT_BASE_DIR && make clean \
    && cd $QT_SCRIPT_DIR && make clean \
    && cd $QT_SVG_DIR && make clean

ADD build.sh /build.sh
CMD ["bash", "/build.sh"]
