// the NPC has less than 100% hit points

int StartingConditional()
{
    int nCurHP = GetCurrentHitPoints();
    int nMaxHP = GetMaxHitPoints();

    if (nCurHP < nMaxHP)
    {
        return TRUE;
    }
    return FALSE;
}
