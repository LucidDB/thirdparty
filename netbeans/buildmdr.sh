# /bin/bash
# $Id$

export CVSROOT=:pserver:anoncvs@cvs.netbeans.org:/cvs
cvs login <<EOF
EOF
cvs -z 6 co standard_nowww apisupport_nowww mdr xtest junit
cd nbbuild
ant all-mdr
cd ../../xtest
ant
cd ../junit
ant
cd ../mdr
ant download
