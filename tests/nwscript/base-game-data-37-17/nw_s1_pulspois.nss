//::///////////////////////////////////////////////
//:: Pulse: Poison
//:: NW_S1_PulsPois
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    A wave of energy emanates from the creature which affects
    all within 10ft.  All who make a reflex save are not
    poisoned.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 23, 2000
//:://////////////////////////////////////////////

void main()
{
    //Declare major variables
    int nDamage = d6(GetHitDice(OBJECT_SELF));
    int nRacial = GetRacialType(OBJECT_SELF);
    int nHD = GetHitDice(OBJECT_SELF);
    int nPoison;
    float fDelay;
    effect ePoison;

    //Determine the poison type based on the Racial Type and HD
    switch (nRacial)
    {
        case RACIAL_TYPE_OUTSIDER:
            if (nHD <= 9)
            {
                nPoison = POISON_QUASIT_VENOM;
            }
            else if (nHD < 13)
            {
                nPoison = POISON_BEBILITH_VENOM;
            }
            else //if (nHD >= 13)
            {
                nPoison = POISON_PIT_FIEND_ICHOR;
            }
        break;
        case RACIAL_TYPE_VERMIN:
            if (nHD < 3)
            {
                nPoison = POISON_TINY_SPIDER_VENOM;
            }
            else if (nHD < 6)
            {
                nPoison = POISON_SMALL_SPIDER_VENOM;
            }
            else if (nHD < 9)
            {
                nPoison = POISON_MEDIUM_SPIDER_VENOM;
            }
            else if (nHD < 12)
            {
                nPoison =  POISON_LARGE_SPIDER_VENOM;
            }
            else if (nHD < 15)
            {
                nPoison = POISON_HUGE_SPIDER_VENOM;
            }
            else if (nHD < 18)
            {
                nPoison = POISON_GARGANTUAN_SPIDER_VENOM;
            }
            else// if (nHD >= 18)
            {
                nPoison = POISON_COLOSSAL_SPIDER_VENOM;
            }
        break;
        default:
            if (nHD < 3)
            {
                nPoison = POISON_NIGHTSHADE;
            }
            else if (nHD < 6)
            {
                nPoison = POISON_BLADE_BANE;
            }
            else if (nHD < 9)
            {
                nPoison = POISON_BLOODROOT;
            }
            else if (nHD < 12)
            {
                nPoison =  POISON_LARGE_SPIDER_VENOM;
            }
            else if (nHD < 15)
            {
                nPoison = POISON_LICH_DUST;
            }
            else if (nHD < 18)
            {
                nPoison = POISON_DARK_REAVER_POWDER;
            }
            else //if (nHD >= 18 )
            {
                nPoison = POISON_BLACK_LOTUS_EXTRACT;
            }
        break;
    }
    effect eImpact = EffectVisualEffect(VFX_IMP_PULSE_NATURE);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eImpact, OBJECT_SELF);
    //Get first target in spell area
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(OBJECT_SELF));
    while(GetIsObjectValid(oTarget))
    {
        if(oTarget != OBJECT_SELF)
        {
            if(!GetIsReactionTypeFriendly(oTarget))
            {
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_PULSE_POISON));
                //Determine effect delay
                fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
                ePoison = EffectPoison(nPoison);
                //Apply the VFX impact and effects
                DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_PERMANENT, ePoison, oTarget));
            }
        }
        //Get next target in spell area
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_LARGE, GetLocation(OBJECT_SELF));
    }
}


