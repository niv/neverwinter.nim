//::///////////////////////////////////////////////
//:: Craft Harper Item
//:: x0_s2_HarpItem
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Will create various items.

    Can create a Harper Pin, which allows another
    to gain access to the Harper Prestige Class. It
    will also grant a token AC bonus. (Floodgate will have to
    script the Harper Item granting access to Harper levels themselves, the
    description will have to remain vague).
    
    100 gp, 50xp
    
    Can also create a potion of Cat's Grace or
    a Potion of Eagle's Splendor.
    
    60gp, 5xp  is the cost
    
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: September 2002
//:://////////////////////////////////////////////
#include "nw_i0_spells"

void main()
{

    //Fire cast spell at event for the specified target
    SignalEvent(OBJECT_SELF, EventSpellCastAt(OBJECT_SELF, 479, FALSE));
    ActionStartConversation(OBJECT_SELF, "x1_harper", FALSE, FALSE);
    
}
