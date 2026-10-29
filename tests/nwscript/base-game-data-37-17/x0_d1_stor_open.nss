//::///////////////////////////////////////////////////
//:: X0_D1_STOR_OPEN
//:: Opens the nearest store object with normal
//:: markup/markdown settings. 
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
        // Use the Appraise skill properly
        gplotAppraiseOpenStore(oStore, GetPCSpeaker());
        // OpenStore(oStore, GetPCSpeaker());
    } else {
        PlayVoiceChat(VOICE_CHAT_CUSS);
    }
}
