//::///////////////////////////////////////////////
//::
//:: Conversation (IN)Visible Init, Long Range
//::
//:: NW_DK_Long2.nss
//::
//:: Copyright (c) 2001 Bioware Corp.
//::
//::
//:://////////////////////////////////////////////
//::
//:: PC INITIATION.
//::
//:: Initiates On Notice, even if PC
//::   was suppose to be hidden.
//:: Only does this if L_TALKTIMES is equal to 0
//::
//:://////////////////////////////////////////////
//::
//:: Created By: Brent
//:: Created On: May 2, 2001
//::
//:://////////////////////////////////////////////

void main()
{
    if ( (GetDistanceToObject(GetLastPerceived()) < 20.0) && (GetLocalInt(OBJECT_SELF,"NW_L_TALKTIMES") == 0))
    {
        ActionWait(1.0);
        if (GetIsPC(GetLastPerceived()) == TRUE)
            ActionStartConversation(GetLastPerceived());
    }
}
