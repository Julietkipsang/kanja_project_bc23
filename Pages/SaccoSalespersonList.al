page 50069 "Sacoo Salesperson"
{
    Caption = 'Salesperson Details';
    PageType = List;
    CardPageId = "Sacoo Salespersion Card";
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Sacco Salesperson";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater("General")
            {
                field("Salesperson ID"; Rec."Salesperson ID")
                {
                    ApplicationArea = All;

                }

                field(Name; Rec.Name)
                {
                    ApplicationArea = All;

                }

                field(Address; Rec.Address)
                {
                    ApplicationArea = All;
                }
                field("City/Towm"; Rec."City/Towm")
                {
                    ApplicationArea = All;
                }

            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("&Update Stations")
            {
                Caption = '&Update Stations';
                Image = ApplyEntries;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                ToolTip = 'Update Stations';
                trigger OnAction()
                begin
                    //UpdateStations();
                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin

    end;




    var


}