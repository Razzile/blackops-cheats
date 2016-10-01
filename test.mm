#include <Liberation.h>

int main() { 
	InstrPatch *patch = new InstrPatch(0x12345, "mov r0, r1");
	return patch->Apply();
}
