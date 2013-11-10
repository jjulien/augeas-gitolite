DESTDIR = "/"

LENS_DEST = "$(DESTDIR)/usr/share/augeas/lenses"
LENS_TEST_DEST = "$(LENS_DEST)/tests"

install:
	install -d -m0755 $(LENS_DEST)
	install -d -m0755 $(LENS_TEST_DEST)
	install -m0644 gitolite.aug $(LENS_DEST)
	install -m0644 tests/test_gitolite.aug $(LENS_TEST_DEST)

