# $Id$

# Unpack all third-party components
nothing:  
	@echo Please specify a target from 
	@echo { all, fennel, farrago, optional, autotools, clean }

# Unpack everything except autotools
all:
	make fennel farrago optional

# Unpack only third-party components needed to build Fennel
fennel: boost stlport resgen

# Unpack only third-party components needed to build Farrago (without Fennel)
farrago: ant_ext javacc junit/junit.jar ant/lib/junit.jar ant mdrlibs enki \
	RmiJdbc csvjdbc janino OpenJava hsqldb macker sqlline jline.jar \
	jgrapht jgraphaddons resgen vjdbc diffj findbugs mysql-connector

ant_ext: ant ant/lib/junit.jar ant/lib/jakarta-oro-2.0.7.jar ant/lib/ant-contrib.jar ant/lib/jsch-0.1.24.jar ant/lib/findbugs-ant.jar

# Unpack only optional third-party components
optional: jswat emma xmlbeans blackhawk tpch log4j jdbcappender jtds

autotools: autoconf automake libtool

# Remove all third-party components
clean:  clean_fennel clean_farrago clean_optional clean_autotools

# Remove only third-party components needed by Fennel
clean_fennel:
	-rm -rf boost stlport stlport4 stlport5

# Remove only third-party components needed by Farrago
clean_farrago:
	-rm -rf ant javacc junit/junit.jar mdrlibs RmiJdbc csvjdbc janino \
	OpenJava enki \
	hsqldb macker sqlline jgrapht jgraphaddons resgen retroweaver \
	log4j jdbcappender jtds vjdbc findbugs

clean_optional: clean_obsolete clean_autotools
	-rm -rf jalopy jswat emma xmlbeans blackhawk tpch

clean_autotools:
	-rm -rf autoconf automake libtool

# Remove components which we used to have but are now obsolete.
# NOTE jvs 20-Apr-2005:  now we use the jgraph.jar from JGraphT
clean_obsolete:
	-rm -rf dynamicjava jgraph icu isql jgrapht7

# Rules for unpacking specific components follow.  Note that as part
# of unpacking, we hide the version, so other parts of the build can
# remain version-independent.

boost:  boost_1_33_0.tar.bz2 boost_1_33_0.gcc4.patch
	-rm -rf boost_1_33_0 $@
	bzip2 -d -k -c $< | tar -x
	mv boost_1_33_0 boost
	touch $@
	patch -p 1 -d $@ -g 0 < boost_1_33_0.gcc4.patch

icu:	icu-2.8.patch.tgz
	-rm -rf $@
	tar xfz $<
	touch $@

# identify gcc version 
GCC_VER := $(shell gcc --version | head -n 1 | cut -f 2-3 -d ' ')
# use stlport4 for g++ 3.3, otherwise stlport5
ifneq (, $(findstring (GCC) 3.3., $(GCC_VER)))
  STLPORT := stlport4
else
  STLPORT := stlport5
endif
stlport: $(STLPORT)
	rm -rf stlport
	ln -s $(STLPORT) stlport

# STLport 4 works with gcc 3.3
stlport4:  STLport-4.6.2.tar.gz
	-rm -rf STLport-4.6.2 $@
	tar xfz $<
	mv STLport-4.6.2 $@
	touch $@

# patched STLport 5 works with gcc 4, and links like STLport 4.
stlport5: STLport-5.0.2.tar.bz2 STLport-5.0.2.gcc4.patch
	-rm -rf STLport $@
	tar xjf $<
	mv STLport $@
	touch $@
	patch -p 1 -d $@ < STLport-5.0.2.gcc4.patch

ant: apache-ant-1.7.0-bin.tar.bz2
	-rm -rf apache-ant-1.7.0 $@
	bzip2 -d -k -c $< | tar -x
	mv apache-ant-1.7.0 ant
	touch $@

javacc: javacc-4.0.tar.gz
	-rm -rf javacc-4.0 $@
	tar xfz $<
	mv javacc-4.0 javacc
	touch $@

junit/junit.jar: junit/junit-4.1.jar
	cp -f junit/junit-4.1.jar junit/junit.jar

ant/lib/junit.jar: ant junit/junit.jar
	cp -f junit/junit.jar ant/lib

ant/lib/jakarta-oro-2.0.7.jar: ant
	cp -f jakarta-oro-2.0.7.jar ant/lib
	touch $@

ant/lib/ant-contrib.jar: ant
	cp -f ant-contrib-1.0b2.jar ant/lib/ant-contrib.jar
	touch $@

ant/lib/jsch-0.1.24.jar: ant
	cp -f jsch-0.1.24.jar ant/lib
	touch $@

ant/lib/findbugs-ant.jar: ant findbugs
	cp -f findbugs/lib/findbugs-ant.jar $@
	touch $@

jgrapht: jgrapht-0.7.1.tar.gz
	-rm -rf jgrapht-0.7.1 $@
	tar xfz $<
	mv jgrapht-0.7.1 jgrapht
	touch $@

jgraphaddons: jgraphaddons-1.0.5-src.zip
	-rm -rf $@
	unzip $< -d $@
	touch $@

sqlline: sqlline-src-1_0_5-eb.jar
	-rm -rf $@
	jar xf $<
	mv sqlline-1_0_5-eb sqlline
	touch $@

# Keep version-numbered jline so we know what version it is.  Copy it
# to jline.jar to keep everyone's build happy. 
# REVIEW: SWZ: 4/25/06: Consider just using the version-numbered JAR as-is
jline.jar: jline-0_9_5.jar
	-rm -rf $@
	cp $< $@
	touch $@

jswat: jswat-2.29.zip
	-rm -rf jswat-2.29 $@
	unzip $<
	mv jswat-2.29 jswat
	touch $@

macker: macker-0.4.1.tar.gz
	-rm -rf macker-0.4.1 $@
	tar xfz $<
	mv macker-0.4.1 macker
	touch $@

mdrlibs: mdrextras.tar.gz mdr-standalone.zip uml2mof.zip
	-rm -rf $@
	tar xfz mdrextras.tar.gz
	unzip mdr-standalone.zip -d mdrlibs
	unzip -n uml2mof.zip -d mdrlibs
	touch $@

enki: eigenbase-enki-0.1.0.tar.gz eigenbase-enki-0.1.0-libs.tar.gz 
	-rm -rf $@
	tar xfz eigenbase-enki-0.1.0.tar.gz
	tar xfz eigenbase-enki-0.1.0-libs.tar.gz
	mv eigenbase-enki-0.1.0 $@
	mv $@/eigenbase-enki-0.1.0.jar $@/enki.jar
	mv $@/eigenbase-enki-0.1.0-src.jar $@/enki-src.jar
	(cd $@ && jar xf eigenbase-enki-0.1.0-doc.jar)
	mv $@/api $@/javadoc
	rm -rf $@/META-INF
	touch $@

RmiJdbc: RmiJdbc-3.01jvs.tar.gz
	-rm -rf $@
	tar xfz $<
	touch $@

vjdbc: vjdbc_1_6_5-jvs.zip
	-rm -rf $@ vjdbc_1_6_5-jvs
	unzip $<
	mv vjdbc_1_6_5-jvs vjdbc
	touch $@

csvjdbc: csvjdbc-r0-10-schoi.zip
	-rm -rf $@
	unzip $<
	mv csvjdbc-r0-10-schoi csvjdbc
	touch $@

janino: janino-2.5.14.zip
	-rm -rf $@
	unzip $<
	mv janino-2.5.14 janino
	touch $@

autoconf: autoconf-2.59.tar.gz
	-rm -rf $@
	tar xfz $<
	mv autoconf-2.59 autoconf
	(cd autoconf && \
		./configure && \
		make && \
		echo && \
		echo "Now, as root, run 'cd $$(pwd)'; make install" && \
		echo)
	touch $@

automake: automake-1.8.3.tar.gz
	-rm -rf $@
	tar xfz $<
	mv automake-1.8.3 automake
	(cd automake && \
		./configure && \
		make && \
		echo && \
		echo "Now, as root, run 'cd $$(pwd)'; make install" && \
		echo)
	touch $@

libtool: libtool-1.5.6.tar.gz
	-rm -rf $@
	tar xfz $<
	mv libtool-1.5.6 libtool
	(cd libtool && \
		./configure && \
		make && \
		echo && \
		echo "Now, as root, run 'cd $$(pwd)'; make install" && \
		echo)
	touch $@

OpenJava: OpenJava-1.1-jvs.tar.bz2
	-rm -rf $@
	tar xfj $<
	mv OpenJava-1.1-jvs $@
	touch $@

hsqldb: hsqldb_1_8_0_2.zip
	-rm -rf $@
	unzip $<
	touch $@

resgen: eigenbase-resgen-1.3.zip
	-rm -rf $@
	unzip $<
	touch $@

jdbcappender: jdbcappender.zip 
	-rm -rf $@ 
	mkdir -p $@
	unzip $< -d $@
	touch $@

diffj: diffj-1.1.1.zip
	-rm -rf $@ diffj-1.1.1
	unzip $<
	mv diffj-1.1.1 $@
	touch $@

log4j: logging-log4j-1.3alpha-8.tar.gz
	-rm -rf $@ logging-log4j-1.3alpha-8
	tar zxf $< 
	mv logging-log4j-1.3alpha-8 $@
	touch $@

jtds: jtds-1.2-dist.zip 
	-rm -rf $@
	unzip $< -d $@
	touch $@

emma: emma-2.0.5312.zip
	-rm -rf $@ emma-2.0.5312
	unzip $<
	mv emma-2.0.5312 $@
	touch $@

blackhawk: blackhawk.tar.bz2
	rm -rf $@ blackhawk
	bzip2 $< -d -k -c | tar -x
	mv dist $@
	touch $@

xmlbeans: xmlbeans-2.1.0.zip
	-rm -rf xmlbeans $@
	unzip $<
	mv xmlbeans-2.1.0 xmlbeans
	touch $@

tpch: tpch.tar.gz
	rm -rf $@
	tar xfz $<
	touch $@

findbugs: findbugs-1.3.2.tar.gz
	-rm -rf findbugs-1.3.2 $@
	tar xfz $<
	mv findbugs-1.3.2 findbugs
	touch $@

mysql-connector: mysql-connector-java-3.1.14.zip
	-rm -rf mysql-connector-java-3.1.14 $@
	unzip -o $<
	mv mysql-connector-java-3.1.14 $@
	touch $@

# End
