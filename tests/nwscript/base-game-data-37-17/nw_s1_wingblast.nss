//::///////////////////////////////////////////////
//:: Dragon Wing Buffet
//:: NW_S1_WingBlast
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The dragon will launch into the air, knockdown
    all opponents who fail a Reflex Save and then
    land on one of those opponents doing damage
    up to a maximum of the Dragons HD + 10.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Feb 4, 2002
//:://////////////////////////////////////////////

void main()
{
    //Declare major variables
    effect eAppear;
    effect eKnockDown = EffectKnockdown();
    int nHP;
    int nCurrent = 0;
    object oVict;
    int nDamage = GetHitDice(OBJECT_SELF);
    int nDC = nDamage;
    nDamage = Random(nDamage) + 11;
    effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_BLUDGEONING);
    effect eVis = EffectVisualEffect(VFX_IMP_PULSE_WIND);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, OBJECT_SELF);
    //Get first target in spell area
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, GetLocation(OBJECT_SELF));
    while(GetIsObjectValid(oTarget))
    {
        if(!GetIsReactionTypeFriendly(oTarget))
        {
                if(GetCreatureSize(oTarget) != CREATURE_SIZE_HUGE)
                {
                    if(!ReflexSave(oTarget, nDC))
                    {
                        DelayCommand(0.01, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eKnockDown, oTarget, 6.0);
                    }
                }
            //Get next target in spell area
            oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_GARGANTUAN, GetLocation(OBJECT_SELF));
        }
    }
    location lLocal;
    lLocal = GetLocation(OBJECT_SELF);
    //Apply the VFX impact and effects
    eAppear = EffectDisappearAppear(lLocal);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAppear, OBJECT_SELF, 6.0);

}
