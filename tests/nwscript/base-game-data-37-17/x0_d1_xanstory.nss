// Advances Xanos's story variable by 1

#include "x0_i0_henchman"

void main()
{
    int nStory = GetLocalInt(GetPCSpeaker(), "XP1_Xanos_Story");
    SetLocalInt(GetPCSpeaker(), "XP1_Xanos_Story", (nStory + 1));
}
