# @copyright@
# Copyright (c) 2006 - 2017 Teradata
# All rights reserved. Stacki(r) v5.x stacki.com
# https://github.com/Teradata/stacki/blob/master/LICENSE.txt
# @copyright@

bootstrap:
	$(STACKBUILD)/bin/package-install -m "Development Tools" "Infrastructure Server"
	$(STACKBUILD)/bin/package-install createrepo genisoimage git emacs vim
