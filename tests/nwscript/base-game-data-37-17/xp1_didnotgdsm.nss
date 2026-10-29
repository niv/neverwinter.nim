// xp1_didnotgdsm
//
// If the PC is of good alignment, he takes an evil hit
// If the PC is of neutral or evil alignment, nothing happens

void main()
{
    int nAlign = GetAlignmentGoodEvil(GetPCSpeaker());
    if (nAlign == ALIGNMENT_GOOD)
    {
        AdjustAlignment(GetPCSpeaker(), ALIGNMENT_EVIL, 3);
    }
}
