int StartingConditional()
{
    int iPlot = GetLocalInt(GetModule(),"NW_G_ARTI_PLOT" + GetTag(OBJECT_SELF));
    object oSpeak = GetLocalObject(OBJECT_SELF,"NW_ARTI_PLOT_PC");
    if ((iPlot == 1) && (oSpeak == GetPCSpeaker()))
    {
        return TRUE;
    }
    return FALSE;
}

