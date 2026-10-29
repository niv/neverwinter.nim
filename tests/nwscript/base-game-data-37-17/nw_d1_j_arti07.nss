void main()
{
    SetLocalInt(GetModule(),"NW_G_ARTI_PLOT" + GetTag(OBJECT_SELF),1);
    SetLocalObject(OBJECT_SELF,"NW_ARTI_PLOT_PC",GetPCSpeaker());
    SetCustomToken(1002,GetName(GetPCSpeaker()));
}

