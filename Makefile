# @copyright@
# Copyright (c) 2006 - 2017 Teradata
# All rights reserved. Stacki(r) v5.x stacki.com
# https://github.com/Teradata/stacki/blob/master/LICENSE.txt
# @copyright@

OS=$(shell common/src/stack/build/build/bin/os)
ifeq ($(OS),redhat)
BUILDOS=centos
ROLLS.OS=redhat
else
ifeq ($(OS),suse)
BUILDOS=sles
ROLLS.OS=sles
endif
endif

ROLLROOT = .

-include $(ROLLSBUILD)/etc/CCRolls.mk

.PHONY: 3rdparty
3rdparty: # we need to do the for all OSes
	cd common && $(ROLLSBUILD)/bin/get3rdparty.py
	cd centos && $(ROLLSBUILD)/bin/get3rdparty.py
	cd sles   && $(ROLLSBUILD)/bin/get3rdparty.py

bootstrap-make:
	$(MAKE) -C $(BUILDOS) -f bootstrap.mk bootstrap
	$(MAKE) -C common/src/stack/build bootstrap

bootstrap: bootstrap-make
ifeq ($(STACKBUILD),)
	@echo
	@echo
	@echo Stacki build environment is now installed. Before you can
	@echo continue you will need to logout and login again. Then re-run
	@echo "make bootstrap" again.
	@echo
	@echo
	@/bin/false # stop the caller from continuing
else
	$(MAKE) 3rdparty
	$(MAKE) -C common/src $@
endif
	$(MAKE) -C $(BUILDOS) -f bootstrap.mk $@
	$(MAKE) -C $(BUILDOS)/src $@


preroll::
	mkdir -p build-$(ROLL)-$(STACK)/graph
	mkdir -p build-$(ROLL)-$(STACK)/nodes
	mkdir -p build-$(ROLL)-$(STACK)/manifest.d
	cp $(BUILDOS)/graph/*  build-$(ROLL)-$(STACK)/graph/
	cp $(BUILDOS)/nodes/*  build-$(ROLL)-$(STACK)/nodes/
	cp common/manifest     build-$(ROLL)-$(STACK)/manifest.d/common.manifest
	cp $(BUILDOS)/manifest build-$(ROLL)-$(STACK)/manifest.d/$(BUILDOS).manifest
	make -C common/src     pkg
	make -C $(BUILDOS)/src pkg

