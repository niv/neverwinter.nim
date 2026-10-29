//::///////////////////////////////////////////////
//:: act_q2djinnstone
//:: FileName
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Gives the player the activation stone for the portal
    in the Rakshasa area
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////


void main()
{
    if (GetLocalInt(OBJECT_SELF, "nGiveStone") == 1)
        return;
    ///Give the player the activation stone
    object oPC = GetPCSpeaker();
    SetLocalInt(OBJECT_SELF, "nGiveStone", 1);

    SetLocalInt(oPC,"FIRSTDJINNITALK", 10);

    CreateItemOnObject("q2cstone", oPC);

}
