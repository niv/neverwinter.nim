void main()
{
    // These should be dead-code-optimized so that the results are just:
    //     CONST.I 1
    //     ACTION Assert
    // for the true cases and nothing for the false ones
    if (0) Assert(FALSE);
    if (1) Assert(TRUE);

    if (1) Assert(TRUE);
    else   Assert(FALSE);

    if (0) Assert(FALSE);
    else   Assert(TRUE);

    // With constant folding
    if (!0) Assert(TRUE);
    if (!1) Assert(FALSE);
    if (1+2+3) Assert(TRUE);
    else Assert(FALSE);
    if (1+2-3) Assert(FALSE);
    else Assert(TRUE);
    if (0 && 1) Assert(FALSE);
    if (0 || 1) Assert(TRUE);

    // These ones can't be dead-code-optimized
    int zero = 0, one = 1;
    if (zero) Assert(FALSE);
    if (!zero) Assert(TRUE);
    if (one) Assert(TRUE);
    if (!one) Assert(FALSE);
    if (zero+one) Assert(TRUE);

    if (zero) Assert(FALSE);
    else Assert(TRUE);

    if (one) Assert(TRUE);
    else Assert(FALSE);
}
