void main()
{
    int i;
    float f;
    object o;

    // Default for loop
    for (i = 0; i < 10; i++) {} Assert(i == 10);
    for (o = OBJECT_SELF; o != OBJECT_INVALID; o = OBJECT_INVALID) {} Assert(o == OBJECT_INVALID);
    for (f = 0.0f; f < 10.0f; f += 1.0f) {} Assert(f >= 10.0f);

    // break and continue
    for (i = 0; i < 10; i++)
    {
        if (i == 5) break;
    } Assert(i == 5);

    int test;
    for (i = 0; i < 10; i++)
    {
        if (i != 5) continue;
        test = i;
    } Assert(test == 5);


    // Omitted statements
    for (;;)    {break;}
    for (i++;;) {break;}
    for (;i++;) {break;}
    for (;;i++) {break;}
}
