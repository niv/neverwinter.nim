//::///////////////////////////////////////////////
//:: Name x2_sp_is_drose
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Ioun Stone Power: Dusty Rose
    Gives the user 1 hours worth of +1 AC bonus,
    Deflection
    Cancels any other Ioun stone powers in effect
    on the PC.
*/
//:://////////////////////////////////////////////
//:: Created By: Keith Warner
//:: Created On: Dec 13/02
//:://////////////////////////////////////////////

void main()
{
    //variables
    effect eVFX, eBonus, eLink, eEffect;

    //from any other ioun stones
    eEffect = GetFirstEffect(OBJECT_SELF);
    while (GetIsEffectValid(eEffect) == TRUE)
    {
        if(GetEffectSpellId(eEffect) > 553 && GetEffectSpellId(eEffect) < 561)
        {
            RemoveEffect(OBJECT_SELF, eEffect);
        }
        eEffect = GetNextEffect(OBJECT_SELF);
    }

    //Apply new ioun stone effect
    eVFX = EffectVisualEffect(501);
    eBonus = EffectACIncrease(1, AC_DEFLECTION_BONUS);
    eLink = EffectLinkEffects(eVFX, eBonus);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, OBJECT_SELF, 3600.0);

}
