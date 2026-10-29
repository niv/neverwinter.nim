// if the Reaper has already told his Chapter 3 stuff

int StartingConditional()
{
    int iResult;

    iResult = GetLocalInt(GetModule(), "x2_Gatekeeper_Ch3Told") == 1;
    return iResult;
}
