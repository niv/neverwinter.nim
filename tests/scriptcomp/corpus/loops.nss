void main()
{
    int i;
    float f;
    object o;

    // Default for loop
    for (i = 0; i < 10; i++) {}
    for (o = OBJECT_SELF; o !=OBJECT_INVALID; o = OBJECT_INVALID) {}
    for (f = 0.0f; f < 10.0f; f += 1.0f) {}

    // Omitted statements
    for (;;)    {break;}
    for (i++;;) {break;}
    for (;i++;) {break;}
    for (;;i++) {break;}
}
