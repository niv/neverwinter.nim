//::///////////////////////////////////////////////////
//:: X0_D1_STOR_OPEN2
//:: Opens the nearest store object with significant
//:: better (for the PC) markup/markdown settings. 
//:: Copyright (c) 2002 Floodgate Entertainment
//:: Created By: Naomi Novik
//:: Created On: 11/11/2002
//::///////////////////////////////////////////////////

#include "nw_i0_plot"
#include "x0_i0_common"

void main()
{
    object oStore = GetNearestObject(OBJECT_TYPE_STORE);
    if (GetIsObjectValid(oStore) == TRUE) {
        // Open store using Appraise skill
        gplotAppraiseOpenStore(oStore, GetPCSpeaker(),-10,10);
    } else {
        PlayVoiceChat(VOICE_CHAT_CUSS);
    }
}
