// Same as pos_implvoid_obj.nss, with an int return type instead of object.
// Mirrors x0_inc_skills.nss, where an int declaration is implemented as void.

int some_function();

void some_function()
{
}

void main()
{
    int nFirst = some_function();
    int nSecond = some_function();

    Assert(nFirst == nSecond, "stale return values are at least consistent");
}
