# This is Makefile for Debian maintainer tasks
# Can be included from $TOPLEVEL/Makefile

doit: all

dput-local:
	file=$$(ls -1t .. | egrep '$(PACKAGE).*changes' | head -1); \
	dput --force localhost ../$$file

deb-ls:
	ls -1t .. | egrep '$(PACKAGE)' | head 

svn-build:
	svn-buildpackage -us -uc -rfakeroot

svn-pbuilder: 
	CC=gcc CXX=g++ svn-buildpackage \
	--svn-builder="pdebuild --buildresult $(pwd)/../build-area

pbuilder:
	mkdir -p /tmp/
	dsc=$$(cd ..; ls ../*.dsc | sort -r | head -1 ); \
	echo [NOTE] pbuilding with: $$dsc; \
	CC=gcc CXX=g++ pdebuild --buildresult /tmp/pdebuild \
		--buildsourceroot fakeroot \
		$$dsc \
		-- -uc -us

deb:
	debuild --lintian --linda -rfakeroot \
		-uc -us \
		-i'(\.svn|\.bzr|\.hg|CVS|RCS)'

deb-bin:
	debuild --lintian --linda -rfakeroot \
		-uc -us \
		-sa -b -i'(\.svn|\.bzr|\.hg|CVS|RCS)'

deb-src:
	debuild --lintian --linda -rfakeroot \
		-uc -us \
		-sa -S -i'(\.svn|\.bzr|\.hg|CVS|RCS)'

deb-bin-sig:
	debuild --lintian --linda -rfakeroot \
		-tc -pgpg -sgpg -k$(GPGKEY) \
		-sa -b -i'(\.svn|\.bzr|\.hg|CVS|RCS)'

deb-src-sig:
	debuild --lintian --linda -rfakeroot \
		-tc -pgpg -sgpg -k$(GPGKEY) \
		-sa -S -i'(\.svn|\.bzr|\.hg|CVS|RCS)'

#  Get new upstream version if it exists
dl-upstream:
	(cd ..; mywebget.pl --new --verbose \
	http://..../xarchiver-1.1.tar.bz2 )

# End of file
