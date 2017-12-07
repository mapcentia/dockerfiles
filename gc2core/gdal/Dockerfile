FROM mapcentia/gc2core:base
MAINTAINER Martin Høgh<mh@mapcentia.com>

RUN export DEBIAN_FRONTEND=noninteractive
ENV DEBIAN_FRONTEND noninteractive

# Install ECW 3.3
RUN wget http://www.kyngchaos.com/files/macosxport/libecwj2-3.3-2006-09-06.zip &&\
	unzip libecwj2-3.3-2006-09-06.zip &&\
	wget http://trac.osgeo.org/gdal/raw-attachment/ticket/3162/libecwj2-3.3-msvc90-fixes.patch &&\
	patch -p0< libecwj2-3.3-msvc90-fixes.patch &&\
	wget http://osgeo-org.1560.x6.nabble.com/attachment/5001530/0/libecwj2-3.3-wcharfix.patch &&\
	wget http://trac.osgeo.org/gdal/raw-attachment/ticket/3366/libecwj2-3.3-NCSPhysicalMemorySize-Linux.patch &&\
	cd libecwj2-3.3/ &&\
	patch -p0< ../libecwj2-3.3-NCSPhysicalMemorySize-Linux.patch &&\
	patch -p1< ../libecwj2-3.3-wcharfix.patch &&\
	./configure &&\
	make &&\
	make install

# Install GDAL 2.2.1 from source
RUN wget http://download.osgeo.org/gdal/2.2.1/gdal221.zip && \
    unzip gdal221.zip &&\
    cd gdal-2.2.1 &&\
    ./configure --with-python=yes --with-ecw=/usr/local

RUN cd gdal-2.2.1 &&\
    make

RUN cd gdal-2.2.1 &&\
    make install &&\
    ldconfig &&\
    ln -s /usr/local/bin/ogr2ogr /usr/bin/ogr2ogr