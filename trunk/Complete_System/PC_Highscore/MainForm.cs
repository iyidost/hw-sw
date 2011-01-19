using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.IO.Ports;
using System.Threading;
using System.Data.SQLite;

namespace PC_Highscore
{
    public partial class MainForm : Form
    {
        private SerialPort serialPort = null;
        private bool shouldRead;
        private int currentPoints;

        public MainForm()
        {
            InitializeComponent();
        }

        private void MainForm_Load(object sender, EventArgs e)
        {
            SerialStart();
            CreateTable();
            RefreshData();
        }

        delegate void HighscoreInvoker();

        public void OpenSubmitHighscore()
        {
            if (this.InvokeRequired)
            {
                this.BeginInvoke(new HighscoreInvoker(OpenSubmitHighscore));
                return;
            }

            SubmitHighscore submitHighscore = new SubmitHighscore(this, currentPoints);
            submitHighscore.ShowDialog();
        }

        public void SerialStart()
        {
            if (serialPort != null)
                return;

            serialPort = new SerialPort("COM1", 115200, Parity.None, 8);
            serialPort.Open();

            shouldRead = true;

            Thread readThread = new Thread(SerialRead);
            readThread.Start();
        }

        public void SerialRead()
        {
            while (shouldRead)
            {
                try
                {
                    string points = serialPort.ReadLine();
                    currentPoints = Convert.ToInt32(points);

                    // Open submit highscore dialog from GUI thread
                    OpenSubmitHighscore();
                }
                catch (TimeoutException)
                {

                }
            }
        }

        public void SendContinueGameAccept()
        {
            serialPort.Write("s");
        }

        public void SerialStop()
        {
            serialPort.Close();
        }

        public void RefreshData()
        {
            listViewHighscores.Items.Clear();

            using (SQLiteConnection connection = new SQLiteConnection("Data Source=highscores.db;"))
            {
                connection.Open();
                IDbCommand dbcmd = connection.CreateCommand();
                dbcmd.CommandText = "SELECT name, score, submitted_at FROM highscores ORDER BY score DESC";
                IDataReader reader = dbcmd.ExecuteReader();
               
                while (reader.Read())
                {
                    ListViewItem listViewItem =  new ListViewItem(reader.GetString(0));
                    listViewItem.SubItems.Add(reader.GetInt32(1).ToString());

                    int submitted_at = reader.GetInt32(2);

                    // Convert unix epoch time to DateTime object
                    DateTime startDate = new DateTime(1970, 1, 1, 0, 0, 0, 0);
                    DateTime submittedDate = startDate.AddSeconds(submitted_at).ToLocalTime();

                    listViewItem.SubItems.Add(submittedDate.ToShortDateString() + " " + submittedDate.ToShortTimeString());

                    listViewHighscores.Items.Add(listViewItem);
                }
                connection.Close();
           }
        }

        private void toolStripButtonRefresh_Click(object sender, EventArgs e)
        {
            RefreshData();
        }

        private void toolStripButtonClear_Click(object sender, EventArgs e)
        {
            using (SQLiteConnection connection = new SQLiteConnection("Data Source=highscores.db;"))
            {
                connection.Open();

                IDbCommand dbcmd = connection.CreateCommand();
                dbcmd.CommandText = "DELETE FROM highscores";
                dbcmd.ExecuteNonQuery();

                connection.Close();
            }

            RefreshData();
        }

        private void CreateTable()
        {
            using (SQLiteConnection connection = new SQLiteConnection("Data Source=highscores.db;"))
            {
                connection.Open();

                IDbCommand dbcmd = connection.CreateCommand();
                dbcmd.CommandText = "CREATE TABLE IF NOT EXISTS highscores (name varchar(200), score int, submitted_at int)";
                dbcmd.ExecuteNonQuery();

                connection.Close();
            }
        }

        private void MainForm_FormClosed(object sender, FormClosedEventArgs e)
        {
            shouldRead = false;
            Application.Exit(0);
        }
    }
}
