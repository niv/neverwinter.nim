//::///////////////////////////////////////////////
//:: Join as Henchman
//:: nw_ch_join.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*

    Adds the current object as a henchman
    to the PC speaking in conversation.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: October 22, 2001
//:://////////////////////////////////////////////


void main()
{
    SetAssociateListenPatterns();
    // * Companions, come in, by default with Attack Nearest Enemy && Follow Master modes
    SetLocalInt(OBJECT_SELF,"NW_COM_MODE_COMBAT",ASSOCIATE_COMMAND_ATTACKNEAREST);
    SetLocalInt(OBJECT_SELF,"NW_COM_MODE_MOVEMENT",ASSOCIATE_COMMAND_FOLLOWMASTER);
    AddHenchman(GetPCSpeaker());
}
