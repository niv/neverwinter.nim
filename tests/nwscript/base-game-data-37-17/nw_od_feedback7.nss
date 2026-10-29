//::///////////////////////////////////////////////
//:: NW_OD_FEEDBACK7.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
  Displays the standard response to a plot door
  being unable to be opened.
*/
//:://////////////////////////////////////////////
//:: Created By:  Brent
//:: Created On:
//:://////////////////////////////////////////////

void main()
{
    SetLocalInt(OBJECT_SELF, "NW_L_FEEDBACK",7) ;
    SpeakOneLinerConversation();
    ActionDoCommand(SetLocalInt(OBJECT_SELF, "NW_L_FEEDBACK",0));

}
