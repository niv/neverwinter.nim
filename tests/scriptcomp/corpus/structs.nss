struct Dummy
{
    int a;
    int b;
    int c;
};

struct Dummy a;
struct Dummy b;

void TakeStruct(struct Dummy d, int a, int b, int c)
{
    Assert(d.a == a);
    Assert(d.b == b);
    Assert(d.c == c);
}
struct Dummy MakeStruct()
{
    struct Dummy x;
    x.a = 100; x.b = 200; x.c = 300;
    return x;
}

void main()
{
    a.a = 1;  a.b = 2;  a.c = 3;
    b.a = 10; b.b = 20; b.c = 30;

    TakeStruct(a, 1, 2, 3);
    TakeStruct(a.a ? a : b, 1, 2, 3);
    TakeStruct(!a.a ? a : b, 10, 20, 30);
    TakeStruct(MakeStruct(), 100, 200, 300);
}
