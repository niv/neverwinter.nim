//::///////////////////////////////////////////////
//:: OnUse: Sit
//:: x2_plc_used_sit
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*

    Simple script to make the creature using a
    placeable sit on it

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-09-18
//:://////////////////////////////////////////////

void main()
{

  object oChair = OBJECT_SELF;
  if(!GetIsObjectValid(GetSittingCreature(oChair)))
  {
    AssignCommand(GetLastUsedBy(), ActionSit(oChair));
  }

}
