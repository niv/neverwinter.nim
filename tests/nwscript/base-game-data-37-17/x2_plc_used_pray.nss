//::///////////////////////////////////////////////
//:: OnUse: Pray
//:: x2_plc_used_pray
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*

    Simple script to make the creature using the
    object pray

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-09-10
//:://////////////////////////////////////////////
void main()
{
    object oSelf = OBJECT_SELF ;
    AssignCommand(GetLastUsedBy(),ActionDoCommand(SetFacingPoint(GetPositionFromLocation(GetLocation(OBJECT_SELF)))));
    AssignCommand(GetLastUsedBy(),ActionPlayAnimation(ANIMATION_LOOPING_MEDITATE,1.0f,1200.0f));
}
