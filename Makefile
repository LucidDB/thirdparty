# $Id$

# Unpack all third-party components
nothing:  
	@echo Please specify a target from 
	@echo { fennel, farrago, optional, autotools, clean }

# Unpack only third-party components needed to build Fennel
fennel: boost stlport icu

# Unpack only third-party components needed to build Farrago (without Fennel)
farrago: ant_ext javacc junit ant/lib/junit.jar ant mdrlibs \
	RmiJdbc csvjdbc janino OpenJava hsqldb macker sqlline 

ant_ext: ant ant/lib/junit.jar ant/lib/jakarta-oro-2.0.7.jar

# Unpack only optional third-party components
optional: isql jswat jalopy 

autotools: autoconf automake libtool

# Remove all third-party components
clean:  clean_fennel clean_farrago clean_optional clean_autotools

# Remove only third-party components needed by Fennel
clean_fennel:
	-rm -rf boost stlport icu

# Remove only third-party components needed by Farrago
clean_farrago:
	-rm -rf ant javacc junit mdrlibs RmiJdbc csvjdbc janino OpenJava \
	hsqldb macker sqlline 

clean_optional: clean_obsolete clean_autotools
	-rm -rf jalopy isql jswat

clean_autotools:
	-rm -rf autoconf automake libtool

# Remove components which we used to have but are now obsolete.
clean_obsolete:
	-rm -rf dynamicjava

# Rules for unpacking specific components follow.  Note that as part
# of unpacking, we hide the version, so other parts of the build can
# remain version-independent.

boost:  boost_1_32_0.tar.bz2
	-rm -rf boost_1_32_0 boost
	bzip2 -d -k -c $< | tar -x
	mv boost_1_32_0 boost
	touch $@

icu:	icu-2.8.patch.tgz
	-rm -rf icu
	tar xfz $<
	touch $@

stlport:  STLport-4.6.2.tar.gz
	-rm -rf STLport-4.6.2 stlport
	tar xfz $<
	mv STLport-4.6.2 stlport
	touch $@

ant: apache-ant-1.6.2-bin.tar.bz2
	-rm -rf apache-ant-1.5.4 ant
	bzip2 -d -k -c $< | tar -x
	mv apache-ant-1.6.2 ant
	touch $@

javacc: javacc-3.2.tar.gz
	-rm -rf javacc-3.2 javacc
	tar xfz $<
	mv javacc-3.2 javacc
	touch $@

junit: junit3.8.1.zip
	-rm -rf junit3.8.1 junit
	unzip $<
	mv junit3.8.1 junit
	touch $@

ant/lib/junit.jar: ant junit
	cp junit/junit.jar ant/lib
	touch $@

ant/lib/jakarta-oro-2.0.7.jar: ant
	cp jakarta-oro-2.0.7.jar ant/lib
	touch $@

jalopy: jalopy-ant-0.6.1.zip
	-rm -rf jalopy
	unzip $< -d jalopy
	touch $@

# TODO jvs 25-March-2004:  get rid of this in a few months
# It's here to clean up leftovers from the old way of unpacking
isql: iSQLViewer
	-rm -rf isql
	mkdir isql

sqlline: sqlline-src-1_0_0.jar
	-rm -rf sqlline
	-rm -rf sqlline-1_0_0
	jar xf $<
	mv sqlline-1_0_0 sqlline
	touch $@

jswat: jswat-2.18.tar.gz
	-rm -rf jswat-2.18 jswat
	tar xfz $<
	mv jswat-2.18 jswat
	touch $@

macker: macker-0.4.1.tar.gz
	-rm -rf macker-0.4.1 macker
	tar xfz $<
	mv macker-0.4.1 macker
	touch $@

mdrlibs: mdrextras.tar.gz mdr-standalone.zip uml2mof.zip
	-rm -rf mdrlibs
	tar xfz mdrextras.tar.gz
	unzip mdr-standalone.zip -d mdrlibs
	unzip -n uml2mof.zip -d mdrlibs
	touch $@

dynamicjava: DynamicJava-1.1.5.zip DynamicJava-1.1.5-src.zip
	-rm -rf dynamicjava djava
	unzip DynamicJava-1.1.5 -d dynamicjava
	unzip DynamicJava-1.1.5-src.zip
	mv djava dynamicjava
	touch $@

RmiJdbc: RmiJdbc-3.01jvs.tar.gz
	-rm -rf RmiJdbc
	tar xfz $<
	touch $@

csvjdbc: csvjdbc-r0-9.zip
	-rm -rf csvjdbc
	unzip $<
	mv csvjdbc-r0-9 csvjdbc
	touch $@

janino: janino-2.0.15.zip janino-2.0.15-src.zip
	-rm -rf janino
	unzip janino-2.0.15.zip
	unzip -n janino-2.0.15-src.zip
	mv janino-2.0.15 janino
	touch $@

autoconf: autoconf-2.59.tar.gz
	-rm -rf autoconf
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
	-rm -rf automake
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
	-rm -rf libtool
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
	-rm -rf OpenJava
	tar xfj $<
	mv OpenJava-1.1-jvs $@
	touch $@

hsqldb: hsqldb_1_7_2_4.zip
	-rm -rf $@
	unzip $<
	touch $@


# End
