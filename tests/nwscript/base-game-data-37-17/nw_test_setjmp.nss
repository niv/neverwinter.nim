void Nested_SetJmp(string sLabel)
{
    if (SetJmp(sLabel))
    {
        AbortRunningScript("FAIL: Nested SetJmp was incorrectly hit: " + sLabel);
    }
}

void Test_LongJmp_Unwound()
{
    WriteTimestampedLogEntry("Test: LongJmp_Unwound");
    if (SetJmp("a"))
    {
        return;
    }

    Nested_SetJmp("a");

    if (GetIsValidJmp("a"))
        AbortRunningScript("FAIL: would jump to unwound/deeper function stack");
}

void Test_LongJmp_Direct_CorrectCandidate()
{
    if (SetJmp("b"))
    {
        AbortRunningScript("FAIL: SetJmp(b) was incorrectly hit");
    }
    if (SetJmp("b"))
    {
        return;
    }

    LongJmp("b");
}

void Test_LongJmp_Scope()
{
    {
        if (SetJmp("inscope_stack_same"))
        {
            return;
        }
    }

    {
        effect e = EffectKnockdown();
        if (SetJmp("inscope_stack_different"))
        {
            return;
        }
    }

    if (SetJmp("outofscope"))
    {
        return;
    }

    if (!GetIsValidJmp("inscope_stack_same"))
        AbortRunningScript("FAIL: inscope_stack_same was not considered jumpable");

    if (!GetIsValidJmp("inscope_stack_different"))
        // this behavior is ok: it is up to the caller to make sure the stack eventually lines up again
        AbortRunningScript("FAIL: inscope_stack_different not was considered jumpable");

    if (!GetIsValidJmp("outofscope"))
        AbortRunningScript("FAIL: outofscope was considered jumpable");

    LongJmp("outofscope");
}

void Test_DeeplyNested_2()
{
    WriteTimestampedLogEntry("Exception test: throwing");
    LongJmp("exception_1");
}

void Test_DeeplyNested_1()
{
    if (SetJmp("exception_1"))
    {
        WriteTimestampedLogEntry("Exception test: OK at level 1");
        LongJmp("exception_0");
        return;
    }

    WriteTimestampedLogEntry("Exception test: calling into 2");
    Test_DeeplyNested_2();
}

void Test_DeeplyNested()
{
    if (SetJmp("exception_0"))
    {
        WriteTimestampedLogEntry("Exception test: OK at root");
        return;
    }
    WriteTimestampedLogEntry("Exception test: calling into 1");
    Test_DeeplyNested_1();
}

void Test_GetIsValidJmp()
{
    if (GetIsValidJmp("a"))
        AbortRunningScript("FAIL: GetIsValidJmp(a)");

    Nested_SetJmp("b");
    if (GetIsValidJmp("b"))
        AbortRunningScript("FAIL: GetIsValidJmp(b)");

    SetJmp("c");
    if (!GetIsValidJmp("c"))
        AbortRunningScript("FAIL: GetIsValidJmp(c)");
}

void Test_Sibling_ImTheSibling()
{
    int a = 1;
    if (SetJmp("sibling"))
    {
        if (a != 2)
            AbortRunningScript("FAIL: Expected stack frame from sibling call");
    }
}

void Test_Sibling()
{
    int a = 2;
    LongJmp("sibling");
}

void main()
{
    Test_LongJmp_Unwound();

    Test_LongJmp_Direct_CorrectCandidate();

    Test_GetIsValidJmp();

    Test_Sibling_ImTheSibling();
    Test_Sibling();

    Test_LongJmp_Scope();

    Test_DeeplyNested();

    AbortRunningScript("All OK!");
    WriteTimestampedLogEntry("This should never print");
}
