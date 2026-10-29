//::///////////////////////////////////////////////
//:: x0_s3_gemspray
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
For Wand of Wonder
This script fires when gem spray ability from wand is activated
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
// Gems go flying out in a cone. All targets in the area take d4() damage
// for each of 1-5 gems, and end up with that number of gems in their
// inventory. Reflex save halves damage.
#include "x0_i0_spells"
// Gems go flying out in a cone. All targets in the area take d4() damage
// for each of 1-5 gems, and end up with that number of gems in their
// inventory. Reflex save halves damage.
void DoFlyingGems(object oCaster, location lTarget);

void DoFlyingGems(object oCaster, location lTarget)
{
    vector vOrigin = GetPosition(oCaster);
    object oTarget = GetFirstObjectInShape(SHAPE_CONE,
                                           30.0,
                                           lTarget,
                                           TRUE,
                                           OBJECT_TYPE_CREATURE,
                                           vOrigin);
    int nGems, nDamage, nRand, i;
    while (GetIsObjectValid(oTarget)) {

        nGems = Random(5) + 1;
        nDamage = 0;
        for (i=0; i < nGems; i++) {
            // Create the gems on the target
            string sResRef = "nw_it_gem0";
            nRand = Random(20);
            if (nRand == 0) {
                sResRef += "11"; // topaz, a nice windfall
            } else if (nRand < 7) {
                sResRef += "02";
            } else if (nRand < 14) {
                sResRef += "05";
            } else {
                sResRef += "08";
            }
            object oGem = CreateItemOnObject(sResRef,
                               oTarget);
            if (GetIsObjectValid(oGem) == FALSE)
            {
                sResRef = GetStringUpperCase(sResRef);
                oGem = CreateItemOnObject(sResRef, oTarget);
                if (GetIsObjectValid(oGem) == FALSE)
                {
                  //  SpeakString("Gem " + sResRef + " is invalid");
                }
           }
            nDamage += d4();
        }

        // Make Reflex save to halve
        if ( MySavingThrow(SAVING_THROW_REFLEX, oTarget, 14)) {
            nDamage = nDamage/2;
        }

        DelayCommand(0.01, ApplyEffectToObject(DURATION_TYPE_INSTANT,
                            EffectDamage(nDamage, DAMAGE_TYPE_BLUDGEONING),
                            oTarget));

        oTarget = GetNextObjectInShape(SHAPE_CONE,
                                       30.0,
                                       lTarget,
                                       TRUE,
                                       OBJECT_TYPE_CREATURE,
                                       vOrigin);
    }
}

void main ()
{
    DoFlyingGems(OBJECT_SELF, GetSpellTargetLocation());
}
