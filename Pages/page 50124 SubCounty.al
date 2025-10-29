page 50048 SubCounty
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = SubCounty;


    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(CountyCode; Rec.CountyCode)
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