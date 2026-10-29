//::///////////////////////////////////////////////
//:: Horse Mounting Repair Horse Situation
//:: x3_fix_horse
//:: Copyright (c) 2007-2008 Bioware Corp.
//:://////////////////////////////////////////////
/*
     Forces Dismount of PC and makes sure no variables are set.
*/
//:://////////////////////////////////////////////
//:: Created By: Deva B. Winblood
//:: Created On: March 19th, 2008
//:: Last Update: March 19th, 2008
//::///////////////////////////////////////////////

#include "x3_inc_horse"

void main()
{
   object oPC=OBJECT_SELF;
   HorseInstantDismount(oPC);
}
