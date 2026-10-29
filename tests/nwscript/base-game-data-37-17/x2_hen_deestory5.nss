// advance Deekin's story global

void main()
{
    int nStory = GetLocalInt(GetModule(), "x2_hen_deekstory");
    SetLocalInt(GetModule(), "x2_hen_deekstory", (nStory + 1));
}
