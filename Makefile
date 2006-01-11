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
farrago: ant_ext javacc junit ant/lib/junit.jar ant mdrlibs \
	RmiJdbc csvjdbc janino OpenJava hsqldb macker sqlline \
	jgrapht jgraphaddons resgen retroweaver \
	log4j jdbcappender jtds

ant_ext: ant ant/lib/junit.jar ant/lib/jakarta-oro-2.0.7.jar ant/lib/ant-contrib.jar

# Unpack only optional third-party components
optional: jswat jalopy

autotools: autoconf automake libtool

# Remove all third-party components
clean:  clean_fennel clean_farrago clean_optional clean_autotools

# Remove only third-party components needed by Fennel
clean_fennel:
	-rm -rf boost stlport

# Remove only third-party components needed by Farrago
clean_farrago:
	-rm -rf ant javacc junit mdrlibs RmiJdbc csvjdbc janino OpenJava \
	hsqldb macker sqlline jgrapht jgraphaddons resgen retroweaver \
	log4j jdbcappender jtds

clean_optional: clean_obsolete clean_autotools
	-rm -rf jalopy jswat

clean_autotools:
	-rm -rf autoconf automake libtool

# Remove components which we used to have but are now obsolete.
# NOTE jvs 20-Apr-2005:  now we use the jgraph.jar from JGraphT
clean_obsolete:
	-rm -rf dynamicjava jgraph icu isql

# Rules for unpacking specific components follow.  Note that as part
# of unpacking, we hide the version, so other parts of the build can
# remain version-independent.

boost:  boost_1_33_0.tar.bz2
	-rm -rf boost_1_33_0 $@
	bzip2 -d -k -c $< | tar -x
	mv boost_1_33_0 boost
	touch $@

icu:	icu-2.8.patch.tgz
	-rm -rf $@
	tar xfz $<
	touch $@

stlport:  STLport-4.6.2.tar.gz
	-rm -rf STLport-4.6.2 $@
	tar xfz $<
	mv STLport-4.6.2 stlport
	touch $@

ant: apache-ant-1.6.5-bin.tar.bz2
	-rm -rf apache-ant-1.6.5 $@
	bzip2 -d -k -c $< | tar -x
	mv apache-ant-1.6.5 ant
	touch $@

javacc: javacc-4.0.tar.gz
	-rm -rf javacc-4.0 $@
	tar xfz $<
	mv javacc-4.0 javacc
	touch $@

junit: junit3.8.1.zip
	-rm -rf junit3.8.1 $@
	unzip $<
	mv junit3.8.1 junit
	touch $@

ant/lib/junit.jar: ant junit
	cp junit/junit.jar ant/lib
	touch $@

ant/lib/jakarta-oro-2.0.7.jar: ant
	cp -f jakarta-oro-2.0.7.jar ant/lib
	touch $@

ant/lib/ant-contrib.jar: ant
	cp -f ant-contrib-1.0b2.jar ant/lib/ant-contrib.jar
	touch $@

jalopy: jalopy-ant-0.6.1.zip
	-rm -rf $@
	unzip $< -d $@
	touch $@

jgrapht: jgrapht-0.7.0alpha.tar.gz
	-rm -rf jgrapht-0.7.0alpha-local $@
	tar xfz $<
	mv jgrapht-0.7.0alpha-local jgrapht
	touch $@

jgraphaddons: jgraphaddons-1.0.5-src.zip
	-rm -rf $@
	unzip $< -d $@
	touch $@

sqlline: sqlline-src-1_0_0.jar
	-rm -rf sqlline-1_0_0$@
	jar xf $<
	mv sqlline-1_0_0 sqlline
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

RmiJdbc: RmiJdbc-3.01jvs.tar.gz
	-rm -rf $@
	tar xfz $<
	touch $@

csvjdbc: csvjdbc-r0-10-schoi.zip
	-rm -rf $@
	unzip $<
	mv csvjdbc-r0-10-schoi csvjdbc
	touch $@

janino: janino-2.3.9.zip
	-rm -rf $@
	unzip $<
	mv janino-2.3.9 janino
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

resgen: eigenbase-resgen.zip
	-rm -rf $@
	unzip $<
	touch $@

retroweaver: retroweaver-all.jar
	-rm -rf $@
	jar xf $<
	touch $@

jdbcappender: jdbcappender.zip 
	-rm -rf $@ 
	mkdir -p $@
	unzip $< -d $@
	touch $@

log4j: logging-log4j-1.3alpha-7.tar.gz
	-rm -rf $@ logging-log4j-1.3alpha-7
	tar zxf $< 
	mv logging-log4j-1.3alpha-7 $@
	touch $@

jtds: jtds-1.2-dist.zip 
	-rm -rf $@
	unzip $< -d $@
	touch $@

# End
