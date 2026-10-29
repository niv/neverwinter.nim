//::///////////////////////////////////////////////
//:: Golem Breath
//:: NW_S1_GolemGas
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Iron Golem spits out a cone of poison.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 22, 2001
//:://////////////////////////////////////////////

void main()
{
    //Declare major variables
    location lTargetLocation = GetSpellTargetLocation();
    object oTarget;
    effect eCone = EffectPoison(POISON_IRON_GOLEM);
    //Get first target in spell area
    oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 10.0, lTargetLocation, TRUE);
    while(GetIsObjectValid(oTarget))
    {
    	if(!GetIsReactionTypeFriendly(oTarget) && oTarget != OBJECT_SELF)
    	{
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLABILITY_GOLEM_BREATH_GAS));
            //Determine effect delay
            float fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
            //Apply poison effect
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eCone, oTarget));
        }
        //Get next target in spell area
        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 10.0, lTargetLocation, TRUE);
    }
}



