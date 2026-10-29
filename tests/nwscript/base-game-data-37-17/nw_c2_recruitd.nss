//::///////////////////////////////////////////////
//:: Responder's User Define
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
     Responder says a random threat the first time they see the player
*/
//:://////////////////////////////////////////////
//:: Created By:  December
//:: Created On:  Brent
//:://////////////////////////////////////////////

void main()
{
    switch(GetUserDefinedEventNumber())
    {
        case 1002:
            if (GetLocalInt(OBJECT_SELF, "NW_L_RESPONDSTATE") == 0)
            {
                object oPC = GetNearestCreature(CREATURE_TYPE_PLAYER_CHAR, PLAYER_CHAR_IS_PC, OBJECT_SELF, 1, CREATURE_TYPE_PERCEPTION, PERCEPTION_SEEN);
                if (GetIsObjectValid(oPC) == TRUE)
                {
                    SetLocalInt(OBJECT_SELF, "NW_L_RESPONDSTATE", 1);
                    // * only 20 % chance of saying something
                    if (Random(100) <= 40)
                        SpeakOneLinerConversation();
                }
            }
     }
}
