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

    // Nested switch
    switch (N)
    {
        case N:
        {
            switch (N+1)
            {
                case N+1: Assert(TRUE);  break;
                case 0:   Assert(FALSE); break;
                default:  Assert(FALSE); break;
            }
            break;
        }
        case 0:
        {
            switch (N+1)
            {
                case N+1: Assert(TRUE);  break;
                case 0:   Assert(FALSE); break;
                default:  Assert(FALSE); break;
            }
            break;
        }
        default: Assert(FALSE); break;
    }
}
