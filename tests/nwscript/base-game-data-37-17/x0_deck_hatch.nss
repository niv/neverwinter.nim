/* This is the OnHeartbeat script for the Hatchling object from
 * the Deck of Hazards. It summons a hatchling that follows the
 * caster around. The object is destroyed when the hatchling is
 * transformed into an ancient dragon (good for one fight).
 */

#include "x0_i0_deckmany"

void main()
{
    // Get the stored target
    object oTarget = GetLocalObject(OBJECT_SELF, "X0_DECK_TARGET");
    if (!GetIsObjectValid(oTarget))
        return;

    // Get the stored hatchling
    object oHatch = GetLocalObject(oTarget, "X0_DECK_HATCH");
    if (GetIsObjectValid(oHatch)) {
        // hatchling is still around
        return;
    }

    AssignCommand(oTarget, DoHatchlingDeckCardSummon());
}


