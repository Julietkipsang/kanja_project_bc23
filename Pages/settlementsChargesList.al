page 50084 "settlementCharges"
{
    // version TL2.0

    //AutoSplitKey = true;
    Caption = 'Flat Charges Subform';
    PageType = List;
    CardPageId = "Transaction Types Card";
    SourceTable = "Settlement Charges";


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
                field("MPESA Charges"; Rec."MPESA Charges")
                {
                       ApplicationArea = All;
                }
                field(KanjaCharges; Rec.KanjaCharges)
                {
                  ApplicationArea = All;
                }

                field("Total Charge Amount"; Rec."Total Charge Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
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
