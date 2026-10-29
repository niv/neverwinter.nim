// the prisoner sets the plot global to 50 upon being killed

void main()
{
    int npris1=GetUserDefinedEventNumber();
    if (npris1==1007)
    {
        SetLocalInt(GetModule(),"NW_Resc_Plot",50);
    }
}
