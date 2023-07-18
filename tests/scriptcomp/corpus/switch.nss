const int N = 10;
const string S = "nwn";

void main()
{
    int n = N;
    switch (n)
    {
        case N:    Assert(TRUE); break;
        case N+1:  Assert(FALSE); break;
        case 1:    Assert(FALSE); break;
        case 1+1:  Assert(FALSE); break;
        case -1:   Assert(FALSE); break;
        case -N:   Assert(FALSE); break;
        case S:    Assert(FALSE); break;
        case S+S:  Assert(FALSE); break;
        default:   Assert(FALSE); break;
    }
}
