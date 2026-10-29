//::///////////////////////////////////////////////
//:: GreaterWildShape IV - Mindflayer Mindblast
//:: x2_s2_riderdark
//:: Copyright (c) 2003Bioware Corp.
//:://////////////////////////////////////////////
/*

    Does a Mindblast against the selected Target

    Range    : 15.0f,
    DC       : 10+ casterlevel/2 + wisdome modifier
    Duration : d4()

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: July, 07, 2003
//:://////////////////////////////////////////////

#include "x2_i0_spells"
#include "x2_inc_shifter"

void main()
{
    //--------------------------------------------------------------------------
    // Enforce artifical use limit on that ability
    //--------------------------------------------------------------------------
    if (ShifterDecrementGWildShapeSpellUsesLeft() <1 )
    {
        FloatingTextStrRefOnCreature(83576, OBJECT_SELF);
        return;
    }
    int nDC = ShifterGetSaveDC(OBJECT_SELF,SHIFTER_DC_EASY) + GetAbilityModifier(ABILITY_WISDOM,OBJECT_SELF);

    // Do the mind blast DC 19 ....
    DoMindBlast(nDC, d4(1), 15.0f);
}
