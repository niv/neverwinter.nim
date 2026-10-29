// increases Deekin's friendship global by 1

void main()
{
    int nLike = GetLocalInt(GetModule(), "iDeekinFriendship");
    SetLocalInt(GetModule(), "iDeekinFriendship", (nLike + 1));
}
