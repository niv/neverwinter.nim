//::///////////////////////////////////////////////
//::
//:: Conversation (IN)Visible Init, Short Range
//::
//:: NW_DK_Short2.nss
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


// * Known Bugs
// * May 4, 2001
//    OnNotice only fires once so this one fails
//    if onnoticed creature was not in range.
void main()
{
    if ( (GetDistanceToObject(GetLastPerceived()) < 10.0) && (GetLocalInt(OBJECT_SELF,"NW_L_TALKTIMES") == 0))
    {
        if (GetIsPC(GetLastPerceived()) == TRUE)
            ActionStartConversation(GetLastPerceived());
    }
}
