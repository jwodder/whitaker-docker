FROM debian:jessie
RUN apt-get update && apt-get install -y --no-install-recommends \
			gnat \
			unzip \
			wget && \
	apt-get clean && rm -rf /var/lib/apt/lists/*

RUN set -x && \
	mkdir /build && \
	cd /build && \
	wget http://archives.nd.edu/whitaker/wordsall.zip && \
	unzip wordsall.zip && \
	rm wordsall.zip && \
	gnatmake -O3 words && \
	gnatmake makedict && \
	gnatmake makestem && \
	gnatmake makeefil && \
	gnatmake makeinfl && \
	echo G | ./makedict DICTLINE.GEN && \
	echo G | ./makestem STEMLIST.GEN && \
	./makeefil EWSDLIST.GEN && \
	./makeinfl INFLECTS.LAT && \
	mkdir /words && \
	mv words DICTFILE.GEN STEMFILE.GEN INDXFILE.GEN EWDSFILE.GEN \
	    INFLECTS.SEC ADDONS.LAT UNIQUES.LAT /words && \
	cd / && \
	rm -rf /build

WORKDIR /words
CMD ["/words/words"]
