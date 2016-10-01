#include <substrate.h>
#include <Foundation/Foundation.h>
#include <mach-o/dyld.h>
#include <fstream>
#include <Liberation.h>

#define ASLR_BIAS _dyld_get_image_vmaddr_slide(0)
#define DVAR_SET_VALUE(x, y) if(!strcmp(dvar, x)) {ret->value = y; return ret;}

#ifdef __LP64__

#define DVAR_RESOLVER_BOOL_ADDR 0x10010C91C
#define DVAR_RESOLVER_INT_ADDR 0x10010CCCC
#define DVAR_RESOLVER_FLOAT_ADDR 0x10010CD3C

#else

#define DVAR_RESOLVER_BOOL_ADDR 0x10D611
#define DVAR_RESOLVER_INT_ADDR 0x10D939
#define DVAR_RESOLVER_FLOAT_ADDR 0x10D981

#endif

using std::ofstream;

template <typename T>
struct Dvar {
	void *unk1;
	void *unk2;
	void *unk3;
	void *unk4;
	T value;
};


Dvar<bool> *(*old_dvar_resolver_bool)(const char *dvar, const char *value, void *unk1, void *unk2);

Dvar<bool> *dvar_resolver_bool(const char *dvar, const char *value, void *unk1, void *unk2) {
	Dvar<bool> *ret = old_dvar_resolver_bool(dvar, value, unk1, unk2);

	DVAR_SET_VALUE("UnlimitedHealth", true);
	DVAR_SET_VALUE("AllWeapons", true);
	DVAR_SET_VALUE("WeaponsUnlimitedAmmo", true);

	DVAR_SET_VALUE("AIGodmode", false);
	DVAR_SET_VALUE("DisableZombieSpawning", false);

	return ret;
}

Dvar<int> *(*old_dvar_resolver_int)(const char *dvar, const char *value, void *unk1, void *unk2);

Dvar<int> *dvar_resolver_int(const char *dvar, const char *value, void *unk1, void *unk2) {
	Dvar<int> *ret = old_dvar_resolver_int(dvar, value, unk1, unk2);

	DVAR_SET_VALUE("doBootsDuration", 8000000);
	DVAR_SET_VALUE("doBattleChickenLife", 8000000);

	DVAR_SET_VALUE("doFateChance", 100);

	DVAR_SET_VALUE("doMetallicBallCount", 32);
	DVAR_SET_VALUE("doOilDrumCount", 16);

	DVAR_SET_VALUE("doPickupBonusMaxItemsPerSpawnpoint", 100);
	DVAR_SET_VALUE("doPickupBonusMinItemsPerSpawnpoint", 100);
	DVAR_SET_VALUE("doPickupRoundBeginMaxItemsPerSpawnpoint", 100);
	DVAR_SET_VALUE("doPickupRoundBeginMinItemsPerSpawnpoint", 100);
	DVAR_SET_VALUE("doPickupRoundCompleteMaxItemsPerSpawnpoint", 100);
	DVAR_SET_VALUE("doPickupRoundCompleteMinItemsPerSpawnpoint", 100);
	DVAR_SET_VALUE("doPickupWaveCompleteMaxItemsPerSpawnpoint", 100);
	DVAR_SET_VALUE("doPickupWaveCompleteMinItemsPerSpawnpoint", 100);

	DVAR_SET_VALUE("doSpeedBoostDuration", 1500);

	DVAR_SET_VALUE("doPointsPerBonusLife", 1);
	DVAR_SET_VALUE("doStartBombs", 99);
	DVAR_SET_VALUE("doStartLives", 99);
	DVAR_SET_VALUE("doStartSpeed", 99);

	DVAR_SET_VALUE("doMaxChickens", 100);
	DVAR_SET_VALUE("doRainbowRingTrapDistance", 2000);

	// always a pickup
	DVAR_SET_VALUE("PickupDropOnDeathProbability", 100);
	DVAR_SET_VALUE("MaxPickupsPerWave", 100000);

	// wallhack
	DVAR_SET_VALUE("ClipPlaneNearZ", 200);

	DVAR_SET_VALUE("PlayerStartAmmo", 99999999);

	DVAR_SET_VALUE("DoublePointsTime", 1000000);
	DVAR_SET_VALUE("CarpenterScoreTime", 10000);
	DVAR_SET_VALUE("DeathMachineTime", 1000000);
	DVAR_SET_VALUE("FireSaleTime", 1000000);
	DVAR_SET_VALUE("InstaKillTime", 1000000);
	DVAR_SET_VALUE("LazarusTime", 1000000);
	DVAR_SET_VALUE("MaxTimeInWater", 1000000);

	return ret;
}

Dvar<float> *(*old_dvar_resolver_float)(const char *dvar, const char *value, void *unk1, void *unk2);

Dvar<float> *dvar_resolver_float(const char *dvar, const char *value, void *unk1, void *unk2) {
	Dvar<float> *ret = old_dvar_resolver_float(dvar, value, unk1, unk2);

	DVAR_SET_VALUE("doAutoAimConeLength", 360.0f);
	DVAR_SET_VALUE("doGravity", 98.0f); // low grav deadops

	// auto aim maxed
	DVAR_SET_VALUE("AimAssistADSLockRange", 0.0f);
	DVAR_SET_VALUE("AimAssistUnlockRange", 360.0f);
	DVAR_SET_VALUE("AimAssistUnlockFOV", 180.0f);

	// speed multiplier
	DVAR_SET_VALUE("WalkSpeed", 3.0f);

	// one hit kills
	DVAR_SET_VALUE("ZombieEasyHealthMultiplier", 0.01f);
	DVAR_SET_VALUE("ZombieHardHealthMultiplier", 0.01f);
	DVAR_SET_VALUE("ZombieNormalHealthMultiplier", 0.01f);

	// no recoil
	DVAR_SET_VALUE("RecoilDrag", 100.0f);

	return ret;
}

__attribute__((constructor))
void Init() {
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
		Patch p(0x100232acc+ASLR_BIAS, 0x21008052);
		p.Apply();
		// Hook dvarB(DVAR_RESOLVER_BOOL_ADDR+ASLR_BIAS, dvar_resolver_bool, &old_dvar_resolver_bool);
		// Hook dvarI(DVAR_RESOLVER_INT_ADDR+ASLR_BIAS, dvar_resolver_int, &old_dvar_resolver_int);
		// Hook dvarF(DVAR_RESOLVER_FLOAT_ADDR+ASLR_BIAS, dvar_resolver_float, &old_dvar_resolver_float);
		//
		// dvarB.Apply();
		// dvarI.Apply();
		// dvarF.Apply();
	});
}
