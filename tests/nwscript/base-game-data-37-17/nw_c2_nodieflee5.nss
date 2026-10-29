//::///////////////////////////////////////////////
//::
//:: Flee if attacked
//::
//:: NW_C2_NoDieFlee5.nss
//::
//:: Copyright (c) 2001 Bioware Corp.
//::
//::
//:://////////////////////////////////////////////
//::
//::
//:: Leave an area if attacked.  Should use the module
//:: to bring me back here after a certain period in time.
//:: Useful for signpost characters.
//::
//:://////////////////////////////////////////////
//::
//:: Created By: Brent
//:: Created On: May 15, 2001
//::
//:://////////////////////////////////////////////
void main()
{

    if (GetLocalInt(OBJECT_SELF,"NW_L_WILLFLEE") == 0)
    {
        SetLocalInt(OBJECT_SELF,"NW_L_WILLFLEE",1);
        ActionStartConversation(GetLastAttacker());
    }
}
