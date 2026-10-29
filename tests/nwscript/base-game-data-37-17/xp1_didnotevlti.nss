// xp1_didnotevlti
//
// If the PC is of evil alignment, he takes a good hit
// If the PC is of neutral or good alignment, nothing happens

void main()
{
    int nAlign = GetAlignmentGoodEvil(GetPCSpeaker());
    if (nAlign == ALIGNMENT_EVIL)
    {
        AdjustAlignment(GetPCSpeaker(), ALIGNMENT_GOOD, 1);
    }
}
