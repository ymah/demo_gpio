###############################################################################
#  © Université Lille 1, The Pip Development Team (2015-2017)                 #
#                                                                             #
#  This software is a computer program whose purpose is to run a minimal,     #
#  hypervisor relying on proven properties such as memory isolation.          #
#                                                                             #
#  This software is governed by the CeCILL license under French law and       #
#  abiding by the rules of distribution of free software.  You can  use,      #
#  modify and/ or redistribute the software under the terms of the CeCILL     #
#  license as circulated by CEA, CNRS and INRIA at the following URL          #
#  "http://www.cecill.info".                                                  #
#                                                                             #
#  As a counterpart to the access to the source code and  rights to copy,     #
#  modify and redistribute granted by the license, users are provided only    #
#  with a limited warranty  and the software's author,  the holder of the     #
#  economic rights,  and the successive licensors  have only  limited         #
#  liability.                                                                 #
#                                                                             #
#  In this respect, the user's attention is drawn to the risks associated     #
#  with loading,  using,  modifying and/or developing or reproducing the      #
#  software by the user in light of its specific status of free software,     #
#  that may mean  that it is complicated to manipulate,  and  that  also      #
#  therefore means  that it is reserved for developers  and  experienced      #
#  professionals having in-depth computer knowledge. Users are therefore      #
#  encouraged to load and test the software's suitability as regards their    #
#  requirements in conditions enabling the security of their systems and/or   #
#  data to be ensured and,  more generally, to use and operate it in the      #
#  same conditions as regards security.                                       #
#                                                                             #
#  The fact that you are presently reading this means that you have had       #
#  knowledge of the CeCILL license and that you accept its terms.             #
###############################################################################

include ../toolchain.mk

# Replace this with your own libgcc's directory
LIBGCC=$(shell dirname $(shell gcc -print-libgcc-file-name -m32))

CFLAGS=-m32 -c -nostdlib --freestanding -I$(LIBPIP)/include/ -I$(LIBPIP)/arch/x86/include/ -fno-stack-protector -no-pie -fno-pic
ASFLAGS=$(CFLAGS)
ASFLAGS+=-I$(LIBPIP)/include/

LDFLAGS=-L$(LIBPIP)/lib -I$(LIBPIP)/include/ -L$(LIBGCC) -melf_i386 -Tlink.ld -lgcc -lpip -Tlink.ld
LDFLAGS2=-L$(LIBPIP)/lib -I$(LIBPIP)/include/ -melf_i386 -Tlinkelf.ld -lpip


ASSOURCES=$(wildcard *.S)
CSOURCES:=$(wildcard *.c)
ASOBJ=$(ASSOURCES:.S=.o)
COBJ=$(CSOURCES:.c=.o)

EXEC=gpio.bin

all: $(EXEC)
	@echo Done.

clean:
	rm -f *.o $(EXEC)

$(EXEC): $(ASOBJ) $(COBJ)
	$(LD)  $(LDFLAGS) $^ -o $@  $(LDFLAGS)

%.o: %.S
	$(AS) $(ASFLAGS) $< -o $@

%.o: %.c
	$(CC) $(CFLAGS) $< -o $@
