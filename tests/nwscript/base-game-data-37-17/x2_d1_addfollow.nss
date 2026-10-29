//::///////////////////////////////////////////////
//:: x2_d1_addfollow
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Will add an NPC as a follower.
        The follower variable needs to be set to false at the end


*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: July 18, 2003
//:://////////////////////////////////////////////

void main()
{
    // * just add the henchman directly and
    // * set the FOLLOWER variable on them

    AddHenchman(GetPCSpeaker(), OBJECT_SELF);
    SetLocalInt(OBJECT_SELF, "X2_JUST_A_FOLLOWER", TRUE);

}
