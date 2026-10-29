// xp1_didnotchati
//
// If the PC is of chaotic alignment, he takes a lawful hit
// If the PC is of neutral or lawful alignment, nothing happens

void main()
{
    int nAlign = GetAlignmentLawChaos(GetPCSpeaker());
    if (nAlign == ALIGNMENT_CHAOTIC)
    {
        AdjustAlignment(GetPCSpeaker(), ALIGNMENT_LAWFUL, 1);
    }
}
