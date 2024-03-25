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
    Assert(__FUNCTION__ == "main");
    outer();
    Assert(PegMatch(__DATE__, "^\\d\\d\\d\\d'-'\\d\\d'-'\\d\\d$"), "Value: " + __DATE__);
    Assert(PegMatch(__TIME__, "^\\d\\d':'\\d\\d':'\\d\\d$"), "Value: " + __TIME__);
    Assert(PegMatch(__SCRIPTCOMP_VERSION__, "^\\d+\\.\\d+\\.\\d+$"), "Value: " + __SCRIPTCOMP_VERSION__);
    Assert(__LINE__ == 24);
}
