//::///////////////////////////////////////////////
//:: FileName: X0_O2_CHAIR_SIT
//:://////////////////////////////////////////////
/*
 Sit on a placeable chair or on an invisible object
 placed on a tileset chair.
*/
//:://////////////////////////////////////////////
//:: Created By: Naomi Novik
//:: Created On: /2002
//:://////////////////////////////////////////////


void main()
{
    object oChair = OBJECT_SELF;
    if (!GetIsObjectValid(GetSittingCreature(OBJECT_SELF))) {
        AssignCommand(GetLastUsedBy(), ActionSit(oChair));
    }
}
