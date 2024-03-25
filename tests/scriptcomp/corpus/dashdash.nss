void inner(string inp)
{
    Assert(__FILE__ == "dashdash");
    Assert(__FUNCTION__ == "inner");
    Assert(inp == "outer");
}

void outer(string inp = __FUNCTION__)
{
    Assert(inp == "outer");
    inner(__FUNCTION__);
    Assert(__FUNCTION__ == "outer");
    Assert(__LINE__ == 13);
}

void main()
{
    inner("outer");
    Assert(__LINE__ == 19);
    Assert(__FUNCTION__ == "main");
    Assert(__LINE__ == 21);
    outer();
    Assert(PegMatch(__DATE__, "^\\d\\d\\d\\d'-'\\d\\d'-'\\d\\d$"));
    Assert(PegMatch(__TIME__, "^\\d\\d':'\\d\\d':'\\d\\d$"));
}
