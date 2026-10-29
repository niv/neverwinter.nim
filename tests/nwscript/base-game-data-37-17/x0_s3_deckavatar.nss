/* Script for the Avatar object from the deck of many things,
 * which allows the user to polymorph into an avatar at will.
 */

#include "x0_i0_deckmany"

int GetIsPolymorphed(object oTarget)
{
    effect eEff = GetFirstEffect(oTarget);
    while (GetIsEffectValid(eEff)) {
        if (GetEffectType(eEff) == EFFECT_TYPE_POLYMORPH)
            return TRUE;
        eEff = GetNextEffect(oTarget);
    }
    return FALSE;
}

void main()
{
    // Get the stored target
    object oTarget = OBJECT_SELF;
    if (!GetIsObjectValid(oTarget))
        return;

    // Don't reapply if we're already polymorphed
    if (GetIsPolymorphed(oTarget))
        return;

    DoAvatarDeckCardTransform(oTarget);
}
