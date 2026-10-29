// advance Sharwyn's story global

void main()
{
    int nStory = GetLocalInt(GetModule(), "x2_hen_sharstory");
    SetLocalInt(GetModule(), "x2_hen_sharstory", (nStory + 1));
}
