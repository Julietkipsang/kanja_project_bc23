pageextension 50024 Countries extends "Countries/Regions"
{
    actions
    {
        addbefore("&Country/Region")
        {
            action(countyList)
            {
                RunObject = page County;
                RunPageLink = CountryCode = field(Code);
                ApplicationArea = All;
            }
        }
    }
}
