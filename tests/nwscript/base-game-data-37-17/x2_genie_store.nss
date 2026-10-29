//::///////////////////////////////////////////////
//:: x2_genie_store
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Tries to open the genie store.

    If the store does not exist, it creates it.
    It updates the inventory based on the chapter.
*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: July 31, 2003
//:://////////////////////////////////////////////

#include "nw_i0_plot"

void CreateScrolls(object oStore)
{
    // * spell scrolls
    CreateItemOnObject("x2_it_sparscr304", oStore);
    CreateItemOnObject("nw_it_sparscr312", oStore);
    CreateItemOnObject("x2_it_sparscr502", oStore);
    CreateItemOnObject("x2_it_sparscr304", oStore);
    CreateItemOnObject("x2_it_sparscr901", oStore);
    CreateItemOnObject("x2_it_sparscr205", oStore);
    CreateItemOnObject("x2_it_sparscr501", oStore);
    CreateItemOnObject("x2_it_sparscr206", oStore);
    CreateItemOnObject("x2_it_spdvscr306", oStore);

    CreateItemOnObject("NW_IT_SPDVSCR401", oStore);   // * scroll of restoration

    // * scrolls of raise dead
    CreateItemOnObject("nw_it_spdvscr501", oStore);

    CreateItemOnObject("x1_it_sparscr604", oStore); // stone to flesh

       // * end spell scrolls

}
void CreatePotions(object oStore)
{
    // * placed.


    CreateItemOnObject("nw_it_mpotion012", oStore); // * potion of heal
    CreateItemOnObject("nw_it_mpotion012", oStore); // * potion of heal
    CreateItemOnObject("nw_it_mpotion012", oStore); // * potion of heal
}

void CreateImportant(object oStore)
{
    // * rogue stones
    // CreateItemOnObject("x2_p_rogue", oStore, 5); PLACED NOW
    // * rod of reserection
    CreateItemOnObject("nw_wmgmrd002", oStore);
}
// * bJustWeak - if true will only spawn in the lesser grenades
void CreateGrenades(object oStore, int bJustWeak=TRUE)
{
    int nQuantity = 10;
    // * weak
    CreateItemOnObject("x1_wmgrenade001", oStore, nQuantity);
    CreateItemOnObject("x1_wmgrenade002", oStore, nQuantity);
    CreateItemOnObject("x1_wmgrenade003", oStore, nQuantity);
    CreateItemOnObject("x1_wmgrenade004", oStore, nQuantity);
    CreateItemOnObject("x1_wmgrenade006", oStore, nQuantity);
    CreateItemOnObject("x1_wmgrenade007", oStore, nQuantity);
    CreateItemOnObject("x1_wmgrenade005", oStore, nQuantity);
    CreateItemOnObject("x1_it_msmlmisc01", oStore);


    // * powerful
    if (bJustWeak == FALSE)
    {
        CreateItemOnObject("x2_it_acidbomb", oStore, nQuantity / 2);
        CreateItemOnObject("x2_it_firebomb", oStore, nQuantity / 2);
    }


}

void main()
{
    object oStore;

    oStore = GetObjectByTag("x2_genie_store");
    if (GetIsObjectValid(oStore) == FALSE)
    {
        oStore = CreateObject(OBJECT_TYPE_STORE, "x2_genie", GetLocation(OBJECT_SELF));

        // * this system logically assumes that the chapter make
        // * is copying the store between chapters
    }

    // * Add Appropriate Chapter items, once.
    string sTag = GetTag(GetModule());
    if (sTag == "x0_module1" && GetLocalInt(oStore, "CHAPTER1DONE") == FALSE)
    {
      //  SetStoreGold(oStore, 100000);
        SetStoreMaxBuyPrice(oStore, 5000);

        CreatePotions(oStore);
        CreateImportant(oStore);
        CreateScrolls(oStore);
        CreateGrenades(oStore);
        // * magical Weapons
        CreateItemOnObject("x2_sic_renewal", oStore);
        CreateItemOnObject("nw_wplmss006", oStore);
        CreateItemOnObject("nw_wswmdg004", oStore);
        CreateItemOnObject("nw_wblmfl011", oStore);
        CreateItemOnObject("x2_ring_pet", oStore);  // * Stoneeater's Ring



        // * Misc
        CreateItemOnObject("x0_it_mneck001", oStore);  // * Amulet of Turning
        CreateItemOnObject("x2_it_amt_feath", oStore); // * crafting feathers
        CreateItemOnObject("x2_it_amt_feath", oStore);
        CreateItemOnObject("x2_it_amt_feath", oStore);
        CreateItemOnObject("x2_it_amt_feath", oStore);
        CreateItemOnObject("x2_it_amt_feath", oStore);
        CreateItemOnObject("x2_it_cmat_mith", oStore); // * bar of mithral

        // * chapter 1 monk armor
        CreateItemOnObject("nw_mcloth021", oStore);


        SetLocalInt(oStore, "CHAPTER1DONE", TRUE);
        // * nothing special has to happen here
    }
    else
    if (sTag == "x0_module2" && GetLocalInt(oStore, "CHAPTER2DONE") == FALSE)
    {
    //    SetStoreGold(oStore, 100000);
        SetStoreMaxBuyPrice(oStore, 10000);

        CreatePotions(oStore);
        CreateImportant(oStore);
        CreateScrolls(oStore);
        CreateGrenades(oStore, FALSE);
        SetLocalInt(oStore, "CHAPTER2DONE", TRUE);

        // *
        // * MISC
        // *


        CreateItemOnObject("x0_it_mring012", oStore); // * ring of nine lives

        CreateItemOnObject("x2_nash_boot", oStore);
        CreateItemOnObject("X2_MAARCL050", oStore);
        CreateItemOnObject("x0_misc_twand", oStore);
        CreateItemOnObject("x0_misc_prayer", oStore);
        CreateItemOnObject("x2_sequencer3", oStore);

        CreateItemOnObject("x0_it_msmlmisc05", oStore); // * stone of controlling earth elementals
        CreateItemOnObject("x0_it_mthnmisc13", oStore); // * Elixir of Horus-Re
        CreateItemOnObject("bk_pearl_tongue", oStore); // Pearl of tongues
        CreateItemOnObject("x2_belt_001", oStore);   // * Belt immunity to finger-death/power word kill
        CreateItemOnObject("x0_it_mthnmisc04", oStore); // * chime of opening
        CreateItemOnObject("x2_is_blue", oStore); // * blue Ioun Stone
        CreateItemOnObject("x2_is_deepred", oStore); // * Red Ioun Stone
        CreateItemOnObject("X2_WBLMHW006", oStore); // * Fiend Foe - For Divine Champions
        CreateItemOnObject("x2_whip_black", oStore); // * Deathcoil - for Blackguard

        CreateItemOnObject("nw_it_mring030", oStore); // * Ring of Power
        CreateItemOnObject("nw_it_mbelt016", oStore); // * Guiding LIght belt -- immunity to death



        // *
        // * ARMOR
        // *
        CreateItemOnObject("x2_cus_robe1", oStore);
        CreateItemOnObject("x2_armor_003", oStore);
        CreateItemOnObject("x2_armor_002", oStore);
        CreateItemOnObject("x2_armor_001", oStore);
        CreateItemOnObject("x2_cus_lastwords", oStore);
 //       CreateItemOnObject("x2_cus_shiftertu", oStore);   TOO EXPENSIVE
        CreateItemOnObject("x2_cus_armoroffa", oStore);
//        CreateItemOnObject("x2_cus_casielsso", oStore); TOO EXPENSIVE
        CreateItemOnObject("x2_cus_thegilded", oStore);
//        CreateItemOnObject("x2_cus_theironsk", oStore); TOO EXPENSIVE
//        CreateItemOnObject("x2_cus_bindingso", oStore); TOO EXPENSIVE
        CreateItemOnObject("x2_cus_dancerssi", oStore);
        CreateItemOnObject("x2_cus_fletchers", oStore);




        // * Some weapons
        // * magical Weapons
        CreateItemOnObject("nw_waxmbt006", oStore); // * Deepstone Progency immunity to deat


        CreateItemOnObject("nw_wswmdg007", oStore);

        CreateItemOnObject("x2_wmdwraxe006", oStore);
        CreateItemOnObject("x0_wswmbs002", oStore);
        CreateItemOnObject("X0_WSWMDG002", oStore);
        CreateItemOnObject("nw_wbwmsh005", oStore);
        CreateItemOnObject("x0_wblmms002    ", oStore);
        CreateItemOnObject("X2_WMDWRAXE006", oStore);

        CreateItemOnObject("x2_it_wpmwhip5", oStore);  // whip +5
        CreateItemOnObject("x0_wswmka002", oStore);    // katana +5
        CreateItemOnObject("x0_wswmsc002", oStore);    // scimitar +5
        CreateItemOnObject("x0_wplmss002", oStore);    // spear + 5
        CreateItemOnObject("X0_WPLMHB001", oStore);    // halberd + 4


        // * disposable weapons

        CreateItemOnObject("x0_wthmsh001", oStore, 20);    // shuriken +4
        CreateItemOnObject("x0_wthmax001", oStore, 20);    // throwingaxe +4
        CreateItemOnObject("x0_wthmdt001", oStore, 20);    // dart +4

        // * ammunition
        CreateItemOnObject("x2_wammar013", oStore, 75);
        CreateItemOnObject("nw_wammar002", oStore, 75);
        CreateItemOnObject("nw_wammar005", oStore, 75);
        CreateItemOnObject("nw_wammar006", oStore, 75);
        CreateItemOnObject("nw_wammar004", oStore, 75);
        CreateItemOnObject("x2_wammar013", oStore, 75);
        CreateItemOnObject("nw_wammar002", oStore, 75);
        CreateItemOnObject("nw_wammar005", oStore, 75);
        CreateItemOnObject("nw_wammar006", oStore, 75);
        CreateItemOnObject("nw_wammar004", oStore, 75);


        CreateItemOnObject("nw_wammbo010", oStore, 75);
        CreateItemOnObject("x2_wammbu009", oStore, 75);
        CreateItemOnObject("nw_wammbo010", oStore, 75);
        CreateItemOnObject("x2_wammbu009", oStore, 75);






        // * chapter 2 monk armor
        CreateItemOnObject("x2_mcloth001", oStore);




    }
    else
    if (sTag == "x0_module3" && GetLocalInt(oStore, "CHAPTER3DONE") == FALSE)
    {
    //    SetStoreGold(oStore, 100000);
        SetStoreMaxBuyPrice(oStore, 15000);

        SetLocalInt(oStore, "CHAPTER3DONE", TRUE);
        CreatePotions(oStore);
        CreateImportant(oStore);
        CreateScrolls(oStore);
        CreateGrenades(oStore, FALSE);


        // *
        // * Magical, crazy, +8 weapons
        // *
        CreateItemOnObject("X2_IT_MGLOVE008", oStore);
        CreateItemOnObject("X2_WDBMQS006", oStore);
        CreateItemOnObject("X2_WBWMXL005", oStore);
        CreateItemOnObject("X2_WSWMKA005", oStore);
        CreateItemOnObject("X2_WPLMHB005", oStore);
        CreateItemOnObject("X2_WDBMMA005", oStore);
        CreateItemOnObject("X2_WBLMCL005", oStore);
        CreateItemOnObject("X2_WAXMHN005", oStore);
        CreateItemOnObject("X2_WBLMMS005", oStore);
        CreateItemOnObject("X2_WDBMQS005", oStore);
        CreateItemOnObject("X2_WSPMSC005", oStore);
        CreateItemOnObject("X2_WAXMBT005", oStore);
        CreateItemOnObject("X2_WBWMSH009", oStore);
        CreateItemOnObject("X2_WDBMAX205", oStore);
        CreateItemOnObject("X2_WSPMKU005", oStore);
        CreateItemOnObject("X2_WBLMHL005", oStore);
        CreateItemOnObject("X2_WSWMBS005", oStore);
        CreateItemOnObject("X2_WBLMFH005", oStore);
        CreateItemOnObject("X2_WSWMLS006", oStore);
        CreateItemOnObject("X2_WSWMSC005", oStore);
        CreateItemOnObject("X2_WAXMGR005", oStore);
        CreateItemOnObject("X2_WSWMGS005", oStore);
        CreateItemOnObject("X2_WBLMFL005", oStore);
        CreateItemOnObject("X2_WSWMSS005", oStore);
        CreateItemOnObject("X2_WBLMHW005", oStore);
        CreateItemOnObject("X2_WSWMRP005", oStore);
        CreateItemOnObject("X2_WDBMSW005", oStore);
        CreateItemOnObject("X2_WPLMSS005", oStore);
        CreateItemOnObject("X2_WMDWRAXE009", oStore);
        CreateItemOnObject("X2_WSWMDG006", oStore);
        CreateItemOnObject("X2_WMDWRAXE010", oStore);
        CreateItemOnObject("X2_WSWMLS005", oStore);




        // *
        // * Armor
        // *

        CreateItemOnObject("x2_mcloth005", oStore);  // Epic Spell Resistance Mantle
        CreateItemOnObject("x2_armor_004", oStore);
        CreateItemOnObject("x2_ashmlw006", oStore);  // * Chaos shield

        // * chapter 3 monk armor
        CreateItemOnObject("x2_mcloth002", oStore);


        // *
        // * Rings
        // *
        CreateItemOnObject("x2_cus_ring", oStore); // * shiver-ring

        // * disposable weapons
        CreateItemOnObject("x2_wthmsh003", oStore, 20);    // shuriken +6
        CreateItemOnObject("x2_wthmax003", oStore, 20);    // throwingaxe +6
        CreateItemOnObject("x2_wthmdt003", oStore, 20);    // dart +6
        CreateItemOnObject("x2_wthmsh003", oStore, 20);    // shuriken +6
        CreateItemOnObject("x2_wthmax003", oStore, 20);    // throwingaxe +6
        CreateItemOnObject("x2_wthmdt003", oStore, 20);    // dart +6

        // * ammunition
        CreateItemOnObject("x2_wammar013", oStore, 75);
        CreateItemOnObject("nw_wammar002", oStore, 75);
        CreateItemOnObject("nw_wammar005", oStore, 75);
        CreateItemOnObject("nw_wammar006", oStore, 75);
        CreateItemOnObject("nw_wammar004", oStore, 75);

        CreateItemOnObject("nw_wammbo010", oStore, 75);
        CreateItemOnObject("x2_wammbu009", oStore, 75);
        CreateItemOnObject("nw_wammbo010", oStore, 75);
        CreateItemOnObject("x2_wammbu009", oStore, 75);
    }
    //else
    //{
    //    PrintString("TEMP: Module designer has not given this store a valid chapter tag OR already setup for this chapter");
    //}


    if (GetIsObjectValid(oStore) == TRUE)
    {
        gplotAppraiseOpenStore(oStore, GetPCSpeaker());
    }
}
