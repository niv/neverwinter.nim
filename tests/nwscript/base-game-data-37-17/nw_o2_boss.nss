//::///////////////////////////////////////////////
//:: General Treasure Spawn Script   BOSS
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Spawns in general purpose treasure, usable
    by all classes.
*/
//:://////////////////////////////////////////////
//:: Created By:   Brent
//:: Created On:   March 19 2002
//:://////////////////////////////////////////////
#include "NW_O2_CONINCLUDE"

void main()

{
    if (GetLocalInt(OBJECT_SELF,"NW_DO_ONCE") != 0)
    {
       return;
    }
    object oLastOpener = GetLastOpener();

    // * May 13 2002: Must create appropriate treasure for each
    // * faction member in the party.
    if (GetIsObjectValid(oLastOpener) == TRUE)
    {
        object oMember = GetFirstFactionMember(oLastOpener, TRUE);
        while (GetIsObjectValid(oMember) == TRUE)
        {
            GenerateBossTreasure(oMember, OBJECT_SELF);
            oMember = GetNextFactionMember(oLastOpener, TRUE);
        }
        SetLocalInt(OBJECT_SELF,"NW_DO_ONCE",1);
    }
    ShoutDisturbed();
}
