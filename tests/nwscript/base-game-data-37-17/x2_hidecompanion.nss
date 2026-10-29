// * returns true only if more henchmen to call.
int StartingConditional()
{
    int nValue = GetLocalInt(GetModule(), "X2_L_NUM_HENCHES_COME");
    if (nValue > 0)
        return TRUE;
    return FALSE;
}
