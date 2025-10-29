page 50054 "percentChargesList"
{
    // version TL2.0

    //AutoSplitKey = true;
    // Caption = 'Flat Charges Subform';
    PageType = List;
    SourceTable = Settlement;
    //SourceTableView = sorting("Minimum Amount") where("Calculation Method" = filter("Based Flat Amount"));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(settlementTypes; Rec.settlementTypes)
                {
                    Editable = false;

                }
                field(Description; Rec.Description)
                {
                    Editable = false;
                    Visible = false;
                }
                field("Minimum Amount"; Rec."Minimum Amount")
                {
                    ApplicationArea = All;
                }
                field("Maximum Amount"; Rec."Maximum Amount")
                {
                    ApplicationArea = All;
                }
                field(TotalPercentage; Rec.TotalPercentage)
                {
                    Caption = 'Percentage';

                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
    end;

    trigger OnOpenPage()
    begin

    end;

    var



}
