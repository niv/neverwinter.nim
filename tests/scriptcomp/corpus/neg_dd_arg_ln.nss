// EXPECT: 630

// __LINE__ as default args has not been implemented
void outer(int line = __LINE__)
{
}

void main()
{
    outer();
}
