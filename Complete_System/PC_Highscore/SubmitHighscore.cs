using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Data.SQLite;

namespace PC_Highscore
{
    public partial class SubmitHighscore : Form
    {
        private MainForm mainForm;
        private string defaultTextBoxNameText;

        public SubmitHighscore(MainForm mainForm, int points)
        {
            InitializeComponent();

            this.mainForm = mainForm;
            labelPoints.Text = points.ToString();
        }

        private void SubmitHighscore_Load(object sender, EventArgs e)
        {
            // Save default textbox name text
            defaultTextBoxNameText = textBoxName.Text;
        }

        private void textBoxName_Enter(object sender, EventArgs e)
        {
            // Clear text field if text is default
            if (textBoxName.Text == defaultTextBoxNameText)
            {
                textBoxName.Text = "";
            }
        }

        private void textBoxName_Leave(object sender, EventArgs e)
        {
            // If leaving and textbox is empty set text to the default
            if (textBoxName.Text == "")
            {
                textBoxName.Text = defaultTextBoxNameText;
            }
        }

        private void buttonSave_Click(object sender, EventArgs e)
        {
            using (SQLiteConnection connection = new SQLiteConnection("Data Source=highscores.db;"))
            {
                connection.Open();

                IDbCommand dbcmd = connection.CreateCommand();
                dbcmd.CommandText = "INSERT INTO highscores (name, score, submitted_at) VALUES (@name, @score, strftime('%s', 'now'))";
                dbcmd.Parameters.Add(new SQLiteParameter("name", textBoxName.Text));
                dbcmd.Parameters.Add(new SQLiteParameter("score", labelPoints.Text));
                dbcmd.ExecuteNonQuery();
                
                connection.Close();
            }

            mainForm.RefreshData();
            mainForm.SendContinueGameAccept(); // Tell game to continue and restart
            this.Close();
        }

        private void SubmitHighscore_FormClosing(object sender, FormClosingEventArgs e)
        {
            mainForm.SendContinueGameAccept(); // Tell game to continue and restart
        }
    }
}
