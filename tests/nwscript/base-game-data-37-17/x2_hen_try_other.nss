//::///////////////////////////////////////////////
//:: x2_hen_try_other
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    If this henchman hits this line of banter,
    which means he has no valid banter to say,
    he will try and make the other
    henchman say his banter line.

    Special coding here is required to prevent
    "infinite" bantering...
*/
//:://////////////////////////////////////////////
//:: Created By:  Brent
//:: Created On:  September 30, 2003
//:://////////////////////////////////////////////
#include "x0_i0_henchman"
#include "x2_inc_banter"

void main()
{





    // * if pickup banter mode is on, turn it off but
    // * do not show this banter
    if (GetLocalInt(GetModule(), "PICKUP_BANTER") == 10)
    {
        SetLocalInt(GetModule(), "PICKUP_BANTER", 0);
        return; // *EXIT*
    }

    // * find other henchman
    object oMaster = GetMaster(OBJECT_SELF);
    object oSelf = OBJECT_SELF;

    object oHench1 = GetAssociate(ASSOCIATE_TYPE_HENCHMAN, oMaster, 1);
    object oHench2 = GetAssociate(ASSOCIATE_TYPE_HENCHMAN, oMaster, 2);
    object oHench3 = GetAssociate(ASSOCIATE_TYPE_HENCHMAN, oMaster, 3);
    object oBanter = OBJECT_INVALID;

    // * Henchman 1 can be tried
    if (GetIsObjectValid(oHench1) && oHench1 != oSelf && GetIsFollower(oHench1) == FALSE)
    {
        oBanter = oHench1;
    }
    else
    // * Henchman 2 can be tried
    if (GetIsObjectValid(oHench2) && oHench2 != oSelf && GetIsFollower(oHench2) == FALSE)
    {
        oBanter = oHench2;
    }
    else
    // * Henchman 3 can be tried
    if (GetIsObjectValid(oHench3) && oHench3 != oSelf && GetIsFollower(oHench3) == FALSE)
    {
        oBanter = oHench3;
    }

    // * signal them to try to banter
    if (GetIsObjectValid(oBanter) == TRUE)
    {
       // SpeakString("TEMP: x2_hen_try_others : Pickup banter from " + GetName(OBJECT_SELF) + " to " + GetName(oBanter));
        // * Set a variable to say a "pick up" banter was tried
        // * this will prevent an infinite loop of "pick up" banters
        SetLocalInt(GetModule(), "PICKUP_BANTER", 10);
        AssignCommand(oBanter, AttemptInterjectionOrPopup(oBanter, "x2_party_r", oMaster, 0, oBanter));
    }
}
