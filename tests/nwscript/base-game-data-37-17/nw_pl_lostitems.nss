//::///////////////////////////////////////////////
//:: NW_PL_LOSTITEMS
//:: FileName
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    This scripts starts the lost item store.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

void main()
{
   // OpenStore(GetObjectByTag("LostItems"), GetLastUsedBy());
   SetLocalInt(OBJECT_SELF, "NW_L_IAMLOSTSTORE", 10);
   ActionStartConversation(GetLastUsedBy(), "nw_all_feedback");
}
