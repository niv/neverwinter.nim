// advance Linu's story global

void main()
{
    int nStory = GetLocalInt(GetModule(), "x2_hen_linustory");
    SetLocalInt(GetModule(), "x2_hen_linustory", (nStory + 1));
}
