# $Id:$

# Unpack all third-party components
all:  fennel farrago optional

# Unpack only third-party components needed to build Fennel
fennel: boost stlport

# Unpack only third-party components needed to build Farrago (without Fennel)
farrago: ant_ext javacc junit ant/lib/junit.jar ant mdrlibs dynamicjava

ant_ext: ant ant/lib/junit.jar ant/lib/jakarta-oro-2.0.7.jar

# Unpack only optional third-party components
optional: isql jswat jalopy macker sqlline

# Remove all third-party components
clean:  clean_fennel clean_farrago clean_optional

# Remove only third-party components needed by Fennel
clean_fennel:
	-rm -rf boost stlport

# Remove only third-party components needed by Farrago
clean_farrago:
	-rm -rf ant javacc junit mdrlibs dynamicjava

clean_optional:
	-rm -rf jalopy isql jswat macker sqlline

# Rules for unpacking specific components follow.  Note that as part
# of unpacking, we hide the version, so other parts of the build can
# remain version-independent.

boost:  boost-1.30.2.tar.bz2
	-rm -rf boost-1.30.2 boost
	bzip2 -d -k -c $< | tar -x
	mv boost-1.30.2 boost
	touch $@

stlport:  STLport-4.6.1.tar.gz
	-rm -rf STLport-4.6.1 stlport
	tar xfz $<
	mv STLport-4.6.1 stlport
	touch $@

ant: apache-ant-1.6.0-bin.tar.bz2
	-rm -rf apache-ant-1.5.4 ant
	bzip2 -d -k -c $< | tar -x
	mv apache-ant-1.6.0 ant
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

sqlline: sqlline-src-0_7_8.jar
	-rm -rf sqlline
	-rm -rf sqlline-0_7_8
	jar xf $<
	mv sqlline-0_7_8 sqlline
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

mdrlibs: mdrlibs.tar.gz
	-rm -rf mdrlibs
	tar xfz $<
	touch $@

dynamicjava: DynamicJava-1.1.5.zip DynamicJava-1.1.5-src.zip
	-rm -rf dynamicjava djava
	unzip DynamicJava-1.1.5 -d dynamicjava
	unzip DynamicJava-1.1.5-src.zip
	mv djava dynamicjava
	touch $@
