// Advance Deekin's story variable by 1

void main()
{
     int nStory = GetLocalInt(GetPCSpeaker(), "XP1_Deekin_Story");
     SetLocalInt(GetPCSpeaker(), "XP1_Deekin_Story", (nStory + 1));
}
