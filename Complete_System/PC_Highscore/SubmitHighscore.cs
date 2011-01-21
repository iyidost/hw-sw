using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
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
            CheckScorePosition();
        }

        private void CheckScorePosition()
        {
            int myScore = Convert.ToInt32(labelPoints.Text);
            String currentFirstPlaceName = null;
            int currentFirstPlaceScore = -1;

            using (SQLiteConnection connection = new SQLiteConnection("Data Source=highscores.db;"))
            {
                connection.Open();
                IDbCommand dbcmd = connection.CreateCommand();
                dbcmd.CommandText = "SELECT name, score FROM highscores ORDER BY score DESC LIMIT 1";
                IDataReader reader = dbcmd.ExecuteReader();

                if (reader.Read())
                {
                    currentFirstPlaceName = reader.GetString(0);
                    currentFirstPlaceScore = reader.GetInt32(1);
                }
                connection.Close();
            }

            if (myScore > currentFirstPlaceScore && currentFirstPlaceScore >= 0)
            {
                MessageBox.Show("Tillykke! Du har fået førstepladsen på scoreboardet.\n" +
                    "Du har slået " + currentFirstPlaceName + " som før havde førstepladsen med en score på " + currentFirstPlaceScore + "\n" +
                    "dette er en forbedring på " + (myScore - currentFirstPlaceScore) + " points!", "Du har fået førstepladsen!",
                    MessageBoxButtons.OK, MessageBoxIcon.Information);
            }
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
            if (textBoxName.Text == "" || textBoxName.Text == defaultTextBoxNameText)
            {
                MessageBox.Show("Du skal indtaste dit navn for at komme på highscore listen", "Indtast navn", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
            else
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
                this.Close();
            }
        }

        private void SubmitHighscore_FormClosing(object sender, FormClosingEventArgs e)
        {
            mainForm.SendContinueGameAccept(); // Tell game to continue and restart
        }
    }
}
