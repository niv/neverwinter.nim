struct Dummy
{
    int a;
    int b;
    int c;
};

struct Dummy a;
struct Dummy b;

void TakeStruct(struct Dummy d) {}
struct Dummy MakeStruct()
{
    struct Dummy x;
    return x;
}

void main()
{
    TakeStruct(a);
    TakeStruct(a.a ? a : b);
    TakeStruct(MakeStruct());
}
