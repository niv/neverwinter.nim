//::///////////////////////////////////////////////
//:: Plot Wizard Villain OnConversationEnd
//:: nw_g0_plotcnvend
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Plot Wizard OnConversationEnd for villains

    Turn the villain hostile and attack the PC.
*/
//:://////////////////////////////////////////////
//:: Created By: Sydney Tang
//:: Created On: 2002-08-14
//:://////////////////////////////////////////////

void main()
{
    object oPC = GetPCSpeaker();
    int nGoHostile = GetLocalInt(OBJECT_SELF, "GoHostile");
    if (nGoHostile == TRUE)
    {
        ChangeToStandardFaction(OBJECT_SELF, STANDARD_FACTION_HOSTILE);
        ActionAttack(oPC);
    }
}
