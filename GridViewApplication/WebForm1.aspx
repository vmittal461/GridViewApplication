<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WebForm1.aspx.cs" Inherits="GridViewApplication.WebForm1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>CURD OPERATION</title>
  <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.1.5/dist/sweetalert2.all.min.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" integrity="sha512-z3gLpd7yknf1YoNbCzqRKc4qyor8gaKU1qmn+CShxbuBusANI9QpRohGBreCFkKxLhei6S9CQXFEbbKuqLg0DA==" crossorigin="anonymous" referrerpolicy="no-referrer" />
        <script>
            function showAlert(title, message, type) {
                Swal.fire(title, message, type);
            }
        </script>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f1f1f1;
background-image: url("https://www.transparenttextures.com/patterns/arches.png");

            padding: 20px;
        }

        .container {
            max-width: 360px;
            margin: auto;
            background-color: #fff;
            padding: 15px;
            border-radius: 5px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .form-table {
            width: 100%;
        }

            .form-table td {
                padding: 6px;
            }

            .form-table input[type="text"],
            .form-table input[type="email"],
            .form-table input[type="number"] {
                width: 100%;
                padding: 4px;
                border: 1px solid #ccc;
                border-radius: 4px;
            }

            .form-table label {
                font-weight: bold;
            }

            .form-table .btn-submit {
                background-color: #007BFF;
                color: #fff;
                border: none;
                padding: 6px 10px;
                border-radius: 4px;
                cursor: pointer;
            }

                .form-table .btn-submit:hover {
                    background-color: #0056b3;
                }

        .grid-view {
            margin-top: 30px;
        }

            .grid-view .fa-trash {
                color: #cc0000;
                cursor: pointer;
            }

            .grid-view table {
                width: 100%;
                border-collapse: collapse;
            }

            .grid-view th,
            .grid-view td {
                padding: 10px;
                border: 1px solid #ccc;
                text-align: left;
            }

            .grid-view th {
                background-color: #007BFF;
                color: #fff;
            }

        input::-webkit-outer-spin-button,
        input::-webkit-inner-spin-button {
            -webkit-appearance: none;
            margin: 0;
        }

        .edit-icon,
        .delete-icon,
        .update-icon,
        .cancel-icon {
            margin-right: 10px;
            text-decoration: none;
            outline: none !important;
        }

        .no-outline:focus {
            outline: none !important;
        }

        .no-highlight {
            background-color: transparent;
            border: none;
            font-size: 16PX;
        }

            .no-highlight:focus {
                border: none;
                outline: none !important;
            }
            .action-column {
    width: 95px;
}

.action-column a {
    margin-right: 5px; 
}
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <h2>Enter Details</h2>
            <table class="form-table">
                <tr>
                    <td>
                        <label for="Name">Name:</label></td>
                    <td>
                        <asp:TextBox ID="Name" runat="server" required></asp:TextBox></td>
                </tr>
                <tr>
                    <td>
                        <label for="Mail">Email:</label></td>
                    <td>
                        <asp:TextBox ID="Mail" runat="server" TextMode="Email" required></asp:TextBox></td>
                </tr>
                <tr>
                    <td>
                        <label for="Age">Age:</label></td>
                    <td>
                        <asp:TextBox ID="Age" runat="server" type="number" required></asp:TextBox></td>
                </tr>
                <tr>
                    <td>
                        <label for="Phone">Phone No:</label></td>
                    <td>
                        <asp:TextBox ID="Phone" runat="server" required></asp:TextBox></td>
                </tr>
                <tr>
                    <td colspan="2">
                        <asp:Button ID="btn" runat="server" Text="Submit" OnClick="btn_Click" CssClass="btn-submit" />
                    </td>
                </tr>
            </table>
        </div>

        <div class="grid-view">
            <asp:GridView ID="GvData" runat="server" AutoGenerateColumns="False" GridLines="Both" DataKeyNames="id" OnPageIndexChanging="GvData_PageIndexChanging" OnRowCancelingEdit="GvData_RowCancelingEdit" OnRowDeleting="GvData_RowDeleting" OnRowEditing="GvData_RowEditing" OnRowUpdating="Gvdata_RowUpdating">

                <Columns>
                    <asp:TemplateField HeaderText="Id" Visible="false">
                        <ItemTemplate>
                            <asp:Label ID="lblId" runat="server" Text='<%# Eval("Id") %>'></asp:Label>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="txtId" runat="server" Text='<%# Eval("Id") %>' ReadOnly="true" CssClass="no-highlight"></asp:TextBox>
                        </EditItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="name" HeaderText="Name" ItemStyle-BorderWidth="1px" ItemStyle-BorderStyle="Solid" HeaderStyle-BorderWidth="1px" HeaderStyle-BorderStyle="Solid" />
                    <asp:BoundField DataField="email" HeaderText="Email" ItemStyle-BorderWidth="1px" ItemStyle-BorderStyle="Solid" HeaderStyle-BorderWidth="1px" HeaderStyle-BorderStyle="Solid" />
                    <asp:BoundField DataField="phone" HeaderText="Phone No" ItemStyle-BorderWidth="1px" ItemStyle-BorderStyle="Solid" HeaderStyle-BorderWidth="1px" HeaderStyle-BorderStyle="Solid" />
                    <asp:BoundField DataField="age" HeaderText="Age" ItemStyle-BorderWidth="1px" ItemStyle-BorderStyle="Solid" HeaderStyle-BorderWidth="1px" HeaderStyle-BorderStyle="Solid" />
<asp:TemplateField HeaderText="Actions" ItemStyle-CssClass="action-column">
    <ItemTemplate>
        <asp:LinkButton ID="btnEdit" runat="server" CommandName="Edit" CssClass="fa fa-pen-to-square edit-icon no-outline"></asp:LinkButton>
        <asp:LinkButton ID="btnDelete" runat="server" CommandName="Delete" CssClass="fa fa-trash delete-icon"></asp:LinkButton>
    </ItemTemplate>
    <EditItemTemplate>
        <asp:LinkButton ID="btnUpdate" runat="server" CommandName="Update" CssClass="fa fa-check update-icon"></asp:LinkButton>
        <asp:LinkButton ID="btnCancel" runat="server" CommandName="Cancel" CssClass="fa fa-xmark cancel-icon"></asp:LinkButton>
    </EditItemTemplate>
</asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </form>
</body>
</html>
