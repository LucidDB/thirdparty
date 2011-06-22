# $Id$

# NOTE jvs 28-Oct-2008:  References to P4CONFIG in this Makefile
# are a workaround for some serious brain-damage in some versions
# of patch:
# http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=200895

# Unpack all third-party components
nothing:  
	@echo Please specify a target from 
	@echo { all, fennel, farrago, optional, clean }

# Unpack everything
all:
	make fennel farrago optional

# Unpack only third-party components needed to build Fennel
fennel: boost stlport resgen

# Unpack only third-party components needed to build Farrago (without Fennel)
farrago: ant_ext javacc junit/junit.jar ant/lib/junit.jar ant mdrlibs enki \
	csvjdbc janino OpenJava hsqldb macker sqlline jline.jar \
	jgrapht jgraphaddons resgen vjdbc diffj findbugs mysql-connector \
	jetty

ant_ext: ant ant/lib/junit.jar ant/lib/jakarta-oro-2.0.7.jar ant/lib/ant-contrib.jar ant/lib/jsch-0.1.24.jar ant/lib/findbugs-ant.jar

# Unpack only optional third-party components
optional: jswat emma xmlbeans blackhawk tpch log4j jdbcappender jtds ssb

autotools:
	echo autotools are no longer needed by Fennel build!

# Remove all third-party components
clean:  clean_fennel clean_farrago clean_optional clean_autotools

# Remove only third-party components needed by Fennel
clean_fennel:
	-rm -rf boost stlport stlport4 stlport5

# Remove only third-party components needed by Farrago
clean_farrago:
	-rm -rf ant javacc junit/junit.jar mdrlibs csvjdbc janino \
	OpenJava enki \
	hsqldb macker sqlline jgrapht jgraphaddons resgen retroweaver \
	log4j jdbcappender jtds vjdbc findbugs jetty

clean_optional: clean_obsolete clean_autotools
	-rm -rf jalopy jswat emma xmlbeans blackhawk tpch ssb axis

clean_autotools:
	-rm -rf autoconf automake libtool

# Remove components which we used to have but are now obsolete.
# NOTE jvs 20-Apr-2005:  now we use the jgraph.jar from JGraphT
clean_obsolete:
	-rm -rf dynamicjava jgraph icu isql jgrapht7

# Rules for unpacking specific components follow.  Note that as part
# of unpacking, we hide the version, so other parts of the build can
# remain version-independent.

boost:  boost_1_43_0-slimfast.tar.bz2 Boost-fennel.patch
	-rm -rf boost_1_43_0 $@
	bzip2 -d -k -c $< | tar -x
	mv boost_1_43_0 boost
	unset P4CONFIG; patch -p 1 -d $@ < Boost-fennel.patch
	touch $@

icu:	icu-2.8.patch.tgz
	-rm -rf $@
	tar xfz $<
	touch $@

stlport: STLport-5.2.1.tar.bz2 STLport-fennel.patch
	-rm -rf STLport-5.2.1 $@
	tar xjf $<
	mv STLport-5.2.1 $@
	touch $@
	unset P4CONFIG; patch -p 1 -d $@ < STLport-fennel.patch

ant: apache-ant-1.8.2-bin.tar.bz2
	-rm -rf apache-ant-1.8.2 $@
	bzip2 -d -k -c $< | tar -x
	mv apache-ant-1.8.2 ant
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

sqlline: sqlline-src-1_0_8-eb.jar
	-rm -rf $@
	jar xf $<
	mv sqlline-1_0_8-eb sqlline
	touch $@

# Keep version-numbered jline so we know what version it is.  Copy it
# to jline.jar to keep everyone's build happy. 
# REVIEW: SWZ: 4/25/06: Consider just using the version-numbered JAR as-is
jline.jar: jline-0.9.94.jar
	-rm -rf $@
	cp $< $@
	touch $@

jswat: jswat-cli-4.5.zip
	-rm -rf jswat-cli-4.5 $@
	unzip $<
	mv jswat-cli-4.5 jswat
	touch $@

macker: macker-0.4.1.tar.gz
	-rm -rf macker-0.4.1 $@
	tar xfz $<
	mv macker-0.4.1 macker
	touch $@

mdrlibs: mdrextras.tar.gz mdr-standalone.zip uml2mof.zip mdrsrc.tar.bz2
	-rm -rf $@
	tar xfz mdrextras.tar.gz
	tar xCfj netbeans mdrsrc.tar.bz2
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

vjdbc: vjdbc_1_7_0.zip
	-rm -rf $@ vjdbc_1_7_0
	unzip $<
	mv vjdbc_1_7_0 vjdbc
	touch $@

csvjdbc: csvjdbc-r0-10-schoi.zip
	-rm -rf $@
	unzip $<
	mv csvjdbc-r0-10-schoi csvjdbc
	touch $@

janino: janino-2.6.2.r538.zip
	-rm -rf $@
	unzip $<
	mv janino-2.6.2.r538 janino
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

diffj: diffj-1.1.4.zip
	-rm -rf $@ diffj-1.1.4
	unzip $<
	mv diffj-1.1.4 $@
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

xmlbeans: xmlbeans-2.5.0.zip
	-rm -rf xmlbeans $@
	unzip $<
	mv xmlbeans-2.5.0 xmlbeans
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

ssb: ssb.tar.bz2
	rm -rf $@
	bzip2 $< -d -k -c | tar -x
	touch $@

jetty: jetty-distribution-7.0.1.v20091125.tar.bz2
	rm -rf $@
	tar xfj $<
	mv jetty-distribution-7.0.1.v20091125 jetty
	touch $@

axis: axis-bin-1_4.tar.bz2
	-rm -rf $@
	tar xfj $<
	mv axis-1_4 axis
	touch $@

# End
