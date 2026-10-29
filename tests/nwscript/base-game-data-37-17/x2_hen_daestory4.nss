// advance Daelen's story global

void main()
{
    int nStory = GetLocalInt(GetModule(), "x2_hen_daestory");
    SetLocalInt(GetModule(), "x2_hen_daestory", (nStory + 1));
}

