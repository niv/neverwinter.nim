#include "inc_dashdash"

void inner(string inp)
{
    Assert(__FILE__ == "dashdash.nss");
    Assert(__FUNCTION__ == "inner");
    Assert(inp == "outer");
}

void outer(string inp)
{
    Assert(inp == "main");
    inner(__FUNCTION__);
    Assert(__FUNCTION__ == "outer");
    Assert(__LINE__ == 15);
}

void main()
{
    inner("outer");
    Assert(__FUNCTION__ == "main");
    outer(__FUNCTION__);
    Assert(PegMatch(__DATE__, "^\\d\\d\\d\\d'-'\\d\\d'-'\\d\\d$"), "Value: " + __DATE__);
    Assert(PegMatch(__TIME__, "^\\d\\d':'\\d\\d':'\\d\\d$"), "Value: " + __TIME__);
    Assert(__LINE__ == 25);
    dashdash_include();
}
