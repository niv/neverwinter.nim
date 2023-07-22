string foo(int arg)
{
    return IntToString(arg);
}

int multiple_return_paths(int arg)
{
    int a;
    if (arg == 0)
    {
        int b;
        return 0;
    }
    if (arg == 1)
    {
        int c;
        return 1;
    }

    return -1;
}
void main()
{
    string s = foo(12);
    Assert(s == "12", "foo");

    int n0 = multiple_return_paths(0); Assert(n0 == 0, "n0");
    int n1 = multiple_return_paths(1); Assert(n1 == 1, "n1");
    int n2 = multiple_return_paths(2); Assert(n2 == -1, "n2");
}
