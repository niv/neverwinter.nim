//::///////////////////////////////////////////////
//::
//:: Summon: No Death On Damage
//::
//:: NW_C2_SmNoDeath6.nss
//::
//:: Copyright (c) 2001 Bioware Corp.
//::
//::
//:://////////////////////////////////////////////
//::
//::
//:: I summon guards.
//:: Do this by summoning them through conversation.
//:: A user-defined script will then catch this
//:: event and summon guards.
//::
//:: L_GENERICHostileDamaged = 0 : Not annoyed
//:: L_GENERICHostileDamaged = 1 : Annoyed.
//:: L_GENERICHostile = 2 : Summoning guards
//::
//:://////////////////////////////////////////////
//::
//:: Created By: Brent
//:: Created On: April 30, 2001
//::
//:://////////////////////////////////////////////

void main()
{
    ClearAllActions();
    if (GetLocalInt(OBJECT_SELF,"NW_L_GENERICHostileDamaged") == 0)
    {
        // * TEMP, Play an animation; don't want to say anything
        //   cause that looks dumb if you are both attacked and damaged
        SetLocalInt(OBJECT_SELF,"NW_L_GENERICHostile",2);
        ActionStartConversation(GetLastAttacker());
    }
}
