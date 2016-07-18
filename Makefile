#!/usr/bin/make -f
# -*- mode: makefile; coding: utf-8 -*-
# Copyright © 2006 Sergio Talens-Oliag <sto@debian.org>

# VARIABLES
DESTDIR = 

prefix = /usr/local
bindir = $(prefix)/bin
mandir = $(prefix)/share/man
locale = $(prefix)/share/locale

# Calculated variables
pkgname = $(shell head -1 debian/changelog | sed -e 's/ .*//')
version = $(shell head -1 debian/changelog | sed -e 's/^.*(\(.*\)).*$$/\1/')

all:
	@echo Use a target like: dist, install or uninstall

dist:
	# Build distribution tarfile
	test -d $(pkgname)-$(version) && rm -rf $(pkgname)-$(version) || true
	mkdir $(pkgname)-$(version)
	fakeroot debian/rules clean || true
	cp -a COPYING debian Makefile man po src tests $(pkgname)-$(version)
	tar czf ../$(pkgname)-$(version).tar.gz --exclude=.svn $(pkgname)-$(version)
	rm -rf $(pkgname)-$(version)

install:
	# Install script
	install -D -m 0755 src/ssft.sh $(DESTDIR)$(bindir)/ssft.sh
	sed -i -e "\
	  s%@VERSION@%$(version)%g;  \
	  s%@PACKAGE@%$(pkgname)%g;  \
	  s%@LOCALEDIR@%$(locale)%g; \
	" $(DESTDIR)$(bindir)/ssft.sh
	# Install manpages
	install -D -m 0644 man/ssft.sh.1 $(DESTDIR)$(mandir)/man1/ssft.sh.1
	gzip -f9 $(DESTDIR)$(mandir)/man1/ssft.sh.1
	# Install .mo files
	for po in `ls po/*.po 2> /dev/null`; do \
	  lang="`echo $$po | sed -e 's@^po/@@;s@.po$$@@'`"; \
	  ldir="$(DESTDIR)$(locale)/$$lang/LC_MESSAGES"; \
	  mkdir -p $$ldir; \
	  msgfmt "$$po" -o "$$ldir/$(pkgname).mo"; \
	  chmod 0644 "$$ldir/$(pkgname).mo"; \
	done

uninstall:
	# Remove script
	rm -f $(DESTDIR)$(bindir)/ssft.sh
	# Remove manpage
	rm -f $(DESTDIR)$(mandir)/ssft.sh.1.gz
	# Remove .mo files (does not clean up dirs)
	find $(DESTDIR)$(locale)/ -name $(pkgname).mo -exec rm -f {} \;

# Special rule for package developers (L10N)
SHELL_FILES=src/ssft.sh tests/ssft-test.sh
pot: update-pot
update-pot:
	rm -f "po/ssft.pot";
	# Generate new .pot file
	xgettext -L Shell -o "po/ssft.pot" $(SHELL_FILES);
	# Update .po files
	for f in `ls po/*.po 2> /dev/null`; do \
	  echo "Updating '$$f' file";  \
	  msgmerge -U $$f po/ssft.pot; \
          echo "$$f: `msgfmt -o /dev/null --statistics $$f 2>&1`"; \
	done
