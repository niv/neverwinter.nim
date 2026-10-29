// the NPC has less than 50% hit points

int StartingConditional()
{
    int nCurHP = GetCurrentHitPoints();
    int nMaxHP = GetMaxHitPoints();

    if (nCurHP < (nMaxHP / 2))
    {
        return TRUE;
    }
    return FALSE;
}
