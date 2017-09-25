all: Hack

Hack:
	wget -q https://github.com/source-foundry/Hack/archive/master.tar.gz -O Hack-master.tar.gz
	gzip -dc Hack-master.tar.gz | tar -xf -
	mv Hack-master Hack
	rm -f Hack-master.tar.gz

distclean:
	-rm -rf Hack*
