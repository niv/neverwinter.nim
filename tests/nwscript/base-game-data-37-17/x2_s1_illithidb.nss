//::///////////////////////////////////////////////
//:: GreaterWildShape IV - Mindflayer Mindblast
//:: x2_s1_illithidb
//:: Copyright (c) 2003Bioware Corp.
//:://////////////////////////////////////////////
/*

    Does a Mindblast against the selected Target

    Range    : 15.0f,
    DC       : 10+Caster Level
    Duration : d4()

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: July, 07, 2003
//:://////////////////////////////////////////////

#include "x2_i0_spells"

void main()
{
    // Do the mind blast DC 19 ....
    DoMindBlast(19, d4(1), 15.0f);
}
