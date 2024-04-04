// EXPECT: 630

// __FUNCTION__ as default args has not been implemented
void outer(string function = __FUNCTION__)
{
}

void main()
{
    outer();
}
