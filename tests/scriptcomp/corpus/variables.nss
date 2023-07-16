void main()
{
    int a = 1;
    int b = 2;
    int c = 3;
    int d = 4;
    string s = "A";
    float f = 1.0f;

    if (1)
    {
        int a = 10;
        int b = 20;
        int c = 30;
        int d = 40;
        string s = "B";
        float f = 10.0f;

        Assert(a == 10);
        Assert(b == 20);
        Assert(c == 30);
        Assert(d == 40);
        Assert(s == "B");
        Assert(f == 10.0f);
    }

    Assert(a == 1);
    Assert(b == 2);
    Assert(c == 3);
    Assert(d == 4);
    Assert(s == "A");
    Assert(f == 1.0f);
}
