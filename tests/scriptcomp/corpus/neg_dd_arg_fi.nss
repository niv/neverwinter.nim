// EXPECT: 630

// __FILE__ as default args has not been implemented
void outer(string file = __FILE__)
{
}

void main()
{
    outer();
}
