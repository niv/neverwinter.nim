// xp1_didnotlawti
//
// If the PC is of lawful alignment, he takes a chaotic hit
// If the PC is of neutral or chaotic alignment, nothing happens

void main()
{
    int nAlign = GetAlignmentLawChaos(GetPCSpeaker());
    if (nAlign == ALIGNMENT_LAWFUL)
    {
        AdjustAlignment(GetPCSpeaker(), ALIGNMENT_CHAOTIC, 1);
    }
}
