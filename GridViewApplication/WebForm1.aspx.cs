using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace GridViewApplication
{
    public partial class WebForm1 : System.Web.UI.Page
    {
        private readonly string connectionString = @"Data Source=LAPTOP-7BT0GOFM;Initial Catalog=TestDB;Integrated Security=True";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindGridView();
            }
        }

        private void BindGridView()
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();
                SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM data", con);
                DataTable dt = new DataTable();
                da.Fill(dt);
                GvData.DataSource = dt;
                GvData.DataBind();
            }
        }

        private void ExecuteNonQuery(string commandText, SqlParameter[] parameters)
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();
                using (SqlCommand cmd = new SqlCommand(commandText, con))
                {
                    cmd.CommandType = CommandType.Text;
                    cmd.Parameters.AddRange(parameters);
                    cmd.ExecuteNonQuery();
                }
            }
        }

        private bool IsEmailExist(string email, int userId)
        {
            string query = "SELECT COUNT(*) FROM data WHERE email = @Email AND Id != @UserId";

            using (SqlConnection con = new SqlConnection(connectionString))
            {
                con.Open();
                using (SqlCommand command = new SqlCommand(query, con))
                {
                    command.Parameters.AddWithValue("@Email", email);
                    command.Parameters.AddWithValue("@UserId", userId);
                    int count = Convert.ToInt32(command.ExecuteScalar());
                    return count > 0;
                }
            }
        }

        private void ShowAlert(string title, string message, string type)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "SweetAlert",
                $"Swal.fire('{title}', '{message}', '{type}')", true);
        }

        protected void btn_Click(object sender, EventArgs e)
        {
            string email = Mail.Text;

            if (IsEmailExist(email, 0))
            {
                ShowAlert("Error", "Email already exists. Please use a different email.", "error");
                Reset();
            }
            else
            {
                string commandText = "INSERT INTO data VALUES(@Name, @Email, @Phone, @Age)";
                SqlParameter[] parameters = {
                    new SqlParameter("@Name", Name.Text),
                    new SqlParameter("@Email", email),
                    new SqlParameter("@Phone", Phone.Text),
                    new SqlParameter("@Age", Age.Text)
                };

                ExecuteNonQuery(commandText, parameters);
                BindGridView();
                Reset();
                ShowAlert("Success", "Data inserted successfully!", "success");
            }
        }

        private void DeleteData(int userId)
        {
            string commandText = "DELETE FROM data WHERE Id = @UserId";
            SqlParameter[] parameters = { new SqlParameter("@UserId", userId) };
            ExecuteNonQuery(commandText, parameters);
        }

        protected void GvData_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            int userId = Convert.ToInt32(GvData.DataKeys[e.RowIndex].Value);
            DeleteData(userId);
            BindGridView();
            ShowAlert("Success", "Data deleted successfully!", "success");
        }

        protected void GvData_RowEditing(object sender, GridViewEditEventArgs e)
        {
            GvData.EditIndex = e.NewEditIndex;
            BindGridView();
        }

        protected void GvData_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            CancelEditing();
        }

        private void UpdateData(int userId, string name, string email, string phone, string age)
        {
            string commandText = "UPDATE data SET Name = @Name, Email = @Email, Phone = @Phone, Age = @Age WHERE Id = @UserId";
            SqlParameter[] parameters = {
                new SqlParameter("@Name", name),
                new SqlParameter("@Email", email),
                new SqlParameter("@Phone", phone),
                new SqlParameter("@Age", age),
                new SqlParameter("@UserId", userId)
            };

            ExecuteNonQuery(commandText, parameters);
        }

        protected void Gvdata_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            int userId = Convert.ToInt32(GvData.DataKeys[e.RowIndex].Value);
            GridViewRow row = GvData.Rows[e.RowIndex];
            TextBox textName = (TextBox)row.Cells[1].Controls[0];
            TextBox textMail = (TextBox)row.Cells[2].Controls[0];
            TextBox textPhone = (TextBox)row.Cells[3].Controls[0];
            TextBox textAge = (TextBox)row.Cells[4].Controls[0];

            if (IsEmailExist(textMail.Text, userId))
            {
                ShowAlert("Error", "Email already exists. Please use a different email.", "error");
                return;
            }

            UpdateData(userId, textName.Text, textMail.Text, textPhone.Text, textAge.Text);
            CancelEditing();
            ShowAlert("Success", "Data updated successfully!", "success");
        }

        private void CancelEditing()
        {
            GvData.EditIndex = -1;
            BindGridView();
        }

        protected void GvData_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            GvData.PageIndex = e.NewPageIndex;
            BindGridView();
        }

        private void Reset()
        {
            Name.Text = Mail.Text = Age.Text = Phone.Text = string.Empty;
        }
    }
}
