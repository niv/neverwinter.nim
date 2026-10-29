// the NPC has less than 25% hit points

int StartingConditional()
{
    int nCurHP = GetCurrentHitPoints();
    int nMaxHP = GetMaxHitPoints();

    if (nCurHP < (nMaxHP / 4))
    {
        return TRUE;
    }
    return FALSE;
}
