//::///////////////////////////////////////////////
//:: NW_ALL_FEEDBACK5.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Player transports to last recall-bind position.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////
#include "nw_i0_plot"

int CanAffordIt()
{
    string sTag = GetTag(GetModule());
    int nCost = 0;
    if (sTag == "Chapter1" || sTag =="ENDMODULE1")
    {
        nCost = 50;
    }
    else
    if (sTag == "Chapter2" || sTag =="ENDMODULE2")
    {
        nCost = 150;
    }
    else
    if (sTag == "Chapter3" || sTag =="ENDMODULE3")
    {
        nCost = 400;
    }
    // * remove the gold from the player
    // * I'm having the player remove it from himself
    // * but since I'm also destroying it, this will work
    if (GetGold(GetPCSpeaker()) >= nCost)
    {
        TakeGold(nCost, GetPCSpeaker());
        return TRUE;
    }
    return FALSE;
}

void main()
{
   CanAffordIt();
   location lLoc = GetLocalLocation(GetPCSpeaker(), "NW_L_LOC_RECALL");
   // * Portal stores last location to jump to for future players
   SetLocalInt(OBJECT_SELF, "NW_L_LOC_EVERUSED", 1);
   SetLocalLocation(OBJECT_SELF, "NW_L_LOC_LAST_RECALL", lLoc);
   ApplyEffectAtLocation(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_IMP_UNSUMMON), lLoc);
   AssignCommand(GetPCSpeaker(), JumpToLocation(lLoc));
}
