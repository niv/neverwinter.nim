// EXPECT: 617
// A declaration and implementation that differ in a non-void return type must
// stay rejected: the call site reserves a slot sized for the declared type,
// while the implementation writes one sized for its own type. For differing
// sizes (int vs float is the same size, but string/struct are not) this cannot
// be reconciled, so only the "declaration non-void, implementation void" case
// is accepted with a warning.

int some_function();

float some_function()
{
    return 1.0;
}

void main()
{
    int nValue = some_function();
}
