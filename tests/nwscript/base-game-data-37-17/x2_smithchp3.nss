//Checks if smith is in chapter 3 module

int StartingConditional()
{
    int iResult;

    iResult = GetTag(GetModule()) != "x0_module3";
    return iResult;
}
