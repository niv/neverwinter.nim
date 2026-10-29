// advance Tomi's story global

void main()
{
    int nStory = GetLocalInt(GetModule(), "x2_hen_tomistory");
    SetLocalInt(GetModule(), "x2_hen_tomistory", (nStory + 1));
}
