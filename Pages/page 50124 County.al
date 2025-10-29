page 50047 County
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = County;


    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(CountryCode; Rec.CountryCode)
                {

                    ApplicationArea = all;


                }
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(SubCounty)
            {
                ApplicationArea = All;
                Caption = 'SubCounty/SubRegion';
                RunObject = page SubCounty;
                RunPageLink = CountyCode = field(Code);


            }
        }
    }
}