all: st/st

st:
	git clone https://git.suckless.org/st

st/st: | st
	patch -d st -p1 < st-new.patch
	make -C st

.PHONY: clean
clean:
	rm -rf st
