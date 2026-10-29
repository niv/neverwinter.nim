// * Return True if Aribeth is evil Aribeth
int StartingConditional()
{
    object oAribeth = GetObjectByTag("H2_Aribeth");
    if (GetIsObjectValid(oAribeth) == FALSE)
    {
        return FALSE;
    }
    if (GetAlignmentGoodEvil(oAribeth) == ALIGNMENT_EVIL)
    {
        return TRUE;
    }
    return FALSE;

}
